package models

import (
	"database/sql"
	"time"

	"github.com/lib/pq"
)

// Notification represents a notification sent to staff
type Notification struct {
	ID                    string                `json:"id"`
	IncidentID            string                `json:"incidentId"`
	SentToStaffIDs        []string              `json:"sentToStaffIds"`
	DeliveryRule          *string               `json:"deliveryRule,omitempty"`
	SentAt                time.Time             `json:"sentAt"`
	NotificationType      *string               `json:"notificationType,omitempty"`
	ActionRequired        bool                  `json:"actionRequired"`
	UnreadByStaffIDs      []string              `json:"unreadByStaffIds"`
	Escalated             bool                  `json:"escalated"`
	NotificationHistories []NotificationHistory `json:"notificationHistories,omitempty"`
}

// NotificationCreate represents the input for creating a notification
type NotificationCreate struct {
	IncidentID       string   `json:"incidentId"`
	SentToStaffIDs   []string `json:"sentToStaffIds"`
	NotificationType *string  `json:"notificationType,omitempty"`
	DeliveryRule     *string  `json:"deliveryRule,omitempty"`
	ActionRequired   *bool    `json:"actionRequired,omitempty"`
}

// NotificationHistory represents the read/escalation history for a notification
type NotificationHistory struct {
	ID             string     `json:"id"`
	NotificationID string     `json:"notificationId"`
	StaffID        string     `json:"staffId"`
	Read           bool       `json:"read"`
	ReadAt         *time.Time `json:"readAt,omitempty"`
	Escalated      bool       `json:"escalated"`
	EscalatedAt    *time.Time `json:"escalatedAt,omitempty"`
}

// GetNotificationsByIncidentID retrieves all notifications for an incident
func GetNotificationsByIncidentID(db *sql.DB, incidentID string) ([]Notification, error) {
	query := `
		SELECT id, incident_id, sent_to_staff_ids, delivery_rule, sent_at, 
		       notification_type, action_required, unread_by_staff_ids, escalated
		FROM notifications
		WHERE incident_id = $1
		ORDER BY sent_at DESC
	`

	rows, err := db.Query(query, incidentID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var notifications []Notification
	for rows.Next() {
		var notification Notification
		var sentToStaffIDs pq.StringArray
		var unreadByStaffIDs pq.StringArray

		err := rows.Scan(
			&notification.ID,
			&notification.IncidentID,
			&sentToStaffIDs,
			&notification.DeliveryRule,
			&notification.SentAt,
			&notification.NotificationType,
			&notification.ActionRequired,
			&unreadByStaffIDs,
			&notification.Escalated,
		)
		if err != nil {
			return nil, err
		}

		notification.SentToStaffIDs = []string(sentToStaffIDs)
		notification.UnreadByStaffIDs = []string(unreadByStaffIDs)
		notifications = append(notifications, notification)
	}

	return notifications, rows.Err()
}

// GetNotifications retrieves notifications with optional filters
func GetNotifications(db *sql.DB, staffID, incidentID *string, unreadOnly bool) ([]Notification, error) {
	query := `
		SELECT n.id, n.incident_id, n.sent_to_staff_ids, n.delivery_rule, n.sent_at,
		       n.notification_type, n.action_required, n.unread_by_staff_ids, n.escalated
		FROM notifications n
		WHERE 1=1
	`
	args := []interface{}{}
	argIdx := 1

	if staffID != nil {
		query += ` AND $` + string(rune('0'+argIdx)) + ` = ANY(n.sent_to_staff_ids)`
		args = append(args, *staffID)
		argIdx++
	}

	if incidentID != nil {
		query += ` AND n.incident_id = $` + string(rune('0'+argIdx))
		args = append(args, *incidentID)
		argIdx++
	}

	if unreadOnly && staffID != nil {
		query += ` AND $` + string(rune('0'+argIdx)) + ` = ANY(n.unread_by_staff_ids)`
		args = append(args, *staffID)
		argIdx++
	}

	query += ` ORDER BY n.sent_at DESC`

	rows, err := db.Query(query, args...)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var notifications []Notification
	for rows.Next() {
		var notification Notification
		var sentToStaffIDs pq.StringArray
		var unreadByStaffIDs pq.StringArray

		err := rows.Scan(
			&notification.ID,
			&notification.IncidentID,
			&sentToStaffIDs,
			&notification.DeliveryRule,
			&notification.SentAt,
			&notification.NotificationType,
			&notification.ActionRequired,
			&unreadByStaffIDs,
			&notification.Escalated,
		)
		if err != nil {
			return nil, err
		}

		notification.SentToStaffIDs = []string(sentToStaffIDs)
		notification.UnreadByStaffIDs = []string(unreadByStaffIDs)
		notifications = append(notifications, notification)
	}

	return notifications, rows.Err()
}

// CreateNotification creates a new notification
func CreateNotification(db *sql.DB, input NotificationCreate) (*Notification, error) {
	tx, err := db.Begin()
	if err != nil {
		return nil, err
	}
	defer tx.Rollback()

	actionRequired := false
	if input.ActionRequired != nil {
		actionRequired = *input.ActionRequired
	}

	query := `
		INSERT INTO notifications (incident_id, sent_to_staff_ids, notification_type, delivery_rule, action_required, unread_by_staff_ids)
		VALUES ($1, $2, $3, $4, $5, $2)
		RETURNING id, incident_id, sent_to_staff_ids, delivery_rule, sent_at, notification_type, action_required, unread_by_staff_ids, escalated
	`

	var notification Notification
	var sentToStaffIDs pq.StringArray
	var unreadByStaffIDs pq.StringArray

	err = tx.QueryRow(
		query,
		input.IncidentID,
		pq.Array(input.SentToStaffIDs),
		input.NotificationType,
		input.DeliveryRule,
		actionRequired,
	).Scan(
		&notification.ID,
		&notification.IncidentID,
		&sentToStaffIDs,
		&notification.DeliveryRule,
		&notification.SentAt,
		&notification.NotificationType,
		&notification.ActionRequired,
		&unreadByStaffIDs,
		&notification.Escalated,
	)

	if err != nil {
		return nil, err
	}

	notification.SentToStaffIDs = []string(sentToStaffIDs)
	notification.UnreadByStaffIDs = []string(unreadByStaffIDs)

	// Create notification histories for each staff
	for _, staffID := range input.SentToStaffIDs {
		historyQuery := `
			INSERT INTO notification_histories (notification_id, staff_id, read)
			VALUES ($1, $2, false)
		`
		_, err = tx.Exec(historyQuery, notification.ID, staffID)
		if err != nil {
			return nil, err
		}
	}

	if err := tx.Commit(); err != nil {
		return nil, err
	}

	return &notification, nil
}

// MarkNotificationAsRead marks a notification as read for a specific staff member
func MarkNotificationAsRead(db *sql.DB, notificationID, staffID string) error {
	tx, err := db.Begin()
	if err != nil {
		return err
	}
	defer tx.Rollback()

	// Update notification_histories
	historyQuery := `
		UPDATE notification_histories
		SET read = true, read_at = CURRENT_TIMESTAMP
		WHERE notification_id = $1 AND staff_id = $2
	`
	_, err = tx.Exec(historyQuery, notificationID, staffID)
	if err != nil {
		return err
	}

	// Remove staff from unread_by_staff_ids array
	notificationQuery := `
		UPDATE notifications
		SET unread_by_staff_ids = array_remove(unread_by_staff_ids, $1)
		WHERE id = $2
	`
	_, err = tx.Exec(notificationQuery, staffID, notificationID)
	if err != nil {
		return err
	}

	return tx.Commit()
}

// EscalateNotification escalates a notification
func EscalateNotification(db *sql.DB, notificationID string) error {
	tx, err := db.Begin()
	if err != nil {
		return err
	}
	defer tx.Rollback()

	// Mark notification as escalated
	query := `
		UPDATE notifications
		SET escalated = true, updated_at = CURRENT_TIMESTAMP
		WHERE id = $1
	`
	_, err = tx.Exec(query, notificationID)
	if err != nil {
		return err
	}

	// Get incident details for creating new notification to supervisors
	var incidentID string
	err = tx.QueryRow(`SELECT incident_id FROM notifications WHERE id = $1`, notificationID).Scan(&incidentID)
	if err != nil {
		return err
	}

	// Get supervisor staff IDs
	supervisorQuery := `SELECT id FROM staffs WHERE role IN ('admin', 'supervisor') LIMIT 5`
	rows, err := tx.Query(supervisorQuery)
	if err != nil {
		return err
	}
	defer rows.Close()

	var supervisorIDs []string
	for rows.Next() {
		var supervisorID string
		if err := rows.Scan(&supervisorID); err != nil {
			return err
		}
		supervisorIDs = append(supervisorIDs, supervisorID)
	}

	// Create escalated notification
	if len(supervisorIDs) > 0 {
		escalateQuery := `
			INSERT INTO notifications (incident_id, sent_to_staff_ids, notification_type, action_required, unread_by_staff_ids, escalated)
			VALUES ($1, $2, 'escalated', true, $2, true)
		`
		_, err = tx.Exec(escalateQuery, incidentID, pq.Array(supervisorIDs))
		if err != nil {
			return err
		}
	}

	return tx.Commit()
}

// GetNotificationHistories retrieves notification history for a notification
func GetNotificationHistories(db *sql.DB, notificationID string) ([]NotificationHistory, error) {
	query := `
		SELECT id, notification_id, staff_id, read, read_at, escalated, escalated_at
		FROM notification_histories
		WHERE notification_id = $1
		ORDER BY created_at DESC
	`

	rows, err := db.Query(query, notificationID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var histories []NotificationHistory
	for rows.Next() {
		var history NotificationHistory
		err := rows.Scan(
			&history.ID,
			&history.NotificationID,
			&history.StaffID,
			&history.Read,
			&history.ReadAt,
			&history.Escalated,
			&history.EscalatedAt,
		)
		if err != nil {
			return nil, err
		}
		histories = append(histories, history)
	}

	return histories, rows.Err()
}
