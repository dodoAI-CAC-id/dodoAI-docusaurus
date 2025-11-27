package models

import (
	"database/sql"
	"testing"
	"time"

	"github.com/DATA-DOG/go-sqlmock"
	"github.com/lib/pq"
	"github.com/stretchr/testify/assert"
)

// ==================== GetNotificationsByIncidentID Tests ====================

func TestGetNotificationsByIncidentID_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	incidentID := "test-incident-id"
	now := time.Now()
	notificationType := "incident_detected"
	deliveryRule := "immediate"

	rows := sqlmock.NewRows([]string{
		"id", "incident_id", "sent_to_staff_ids", "delivery_rule", "sent_at",
		"notification_type", "action_required", "unread_by_staff_ids", "escalated",
	}).
		AddRow("notif-1", incidentID, pq.StringArray{"staff-1", "staff-2"},
			&deliveryRule, now, &notificationType, true,
			pq.StringArray{"staff-1", "staff-2"}, false)

	mock.ExpectQuery("SELECT (.+) FROM notifications WHERE incident_id = (.+) ORDER BY sent_at DESC").
		WithArgs(incidentID).
		WillReturnRows(rows)

	// Execute
	notifications, err := GetNotificationsByIncidentID(db, incidentID)

	// Assert
	assert.NoError(t, err)
	assert.Len(t, notifications, 1)
	assert.Equal(t, "notif-1", notifications[0].ID)
	assert.Equal(t, incidentID, notifications[0].IncidentID)
	assert.Len(t, notifications[0].SentToStaffIDs, 2)
	assert.Contains(t, notifications[0].SentToStaffIDs, "staff-1")
	assert.Contains(t, notifications[0].SentToStaffIDs, "staff-2")
	assert.True(t, notifications[0].ActionRequired)
	assert.False(t, notifications[0].Escalated)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetNotificationsByIncidentID_EmptyResult(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	incidentID := "incident-no-notifications"

	rows := sqlmock.NewRows([]string{
		"id", "incident_id", "sent_to_staff_ids", "delivery_rule", "sent_at",
		"notification_type", "action_required", "unread_by_staff_ids", "escalated",
	})

	mock.ExpectQuery("SELECT (.+) FROM notifications WHERE incident_id = (.+) ORDER BY sent_at DESC").
		WithArgs(incidentID).
		WillReturnRows(rows)

	// Execute
	notifications, err := GetNotificationsByIncidentID(db, incidentID)

	// Assert
	assert.NoError(t, err)
	assert.Empty(t, notifications)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetNotificationsByIncidentID_DatabaseError(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	incidentID := "test-incident-id"

	mock.ExpectQuery("SELECT (.+) FROM notifications WHERE incident_id = (.+) ORDER BY sent_at DESC").
		WithArgs(incidentID).
		WillReturnError(sql.ErrConnDone)

	// Execute
	notifications, err := GetNotificationsByIncidentID(db, incidentID)

	// Assert
	assert.Error(t, err)
	assert.Nil(t, notifications)
	assert.Equal(t, sql.ErrConnDone, err)
	assert.NoError(t, mock.ExpectationsWereMet())
}

// ==================== GetNotifications Tests ====================

func TestGetNotifications_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	now := time.Now()

	rows := sqlmock.NewRows([]string{
		"id", "incident_id", "sent_to_staff_ids", "delivery_rule", "sent_at",
		"notification_type", "action_required", "unread_by_staff_ids", "escalated",
	}).
		AddRow("notif-1", "incident-1", pq.StringArray{"staff-1", "staff-2"},
			nil, now, nil, true, pq.StringArray{"staff-1"}, false).
		AddRow("notif-2", "incident-2", pq.StringArray{"staff-3"},
			nil, now, nil, false, pq.StringArray{}, false)

	mock.ExpectQuery("SELECT (.+) FROM notifications n WHERE 1=1 ORDER BY n.sent_at DESC").
		WillReturnRows(rows)

	// Execute
	notifications, err := GetNotifications(db, nil, nil, false)

	// Assert
	assert.NoError(t, err)
	assert.Len(t, notifications, 2)
	assert.Equal(t, "notif-1", notifications[0].ID)
	assert.Equal(t, "notif-2", notifications[1].ID)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetNotifications_FilterByStaffID(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	staffID := "staff-1"
	now := time.Now()

	rows := sqlmock.NewRows([]string{
		"id", "incident_id", "sent_to_staff_ids", "delivery_rule", "sent_at",
		"notification_type", "action_required", "unread_by_staff_ids", "escalated",
	}).
		AddRow("notif-1", "incident-1", pq.StringArray{"staff-1", "staff-2"},
			nil, now, nil, true, pq.StringArray{"staff-1"}, false)

	mock.ExpectQuery("SELECT (.+) FROM notifications n WHERE 1=1 AND (.+) = ANY\\(n.sent_to_staff_ids\\) ORDER BY n.sent_at DESC").
		WithArgs(staffID).
		WillReturnRows(rows)

	// Execute
	notifications, err := GetNotifications(db, &staffID, nil, false)

	// Assert
	assert.NoError(t, err)
	assert.Len(t, notifications, 1)
	assert.Contains(t, notifications[0].SentToStaffIDs, staffID)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetNotifications_FilterByIncidentID(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	incidentID := "incident-1"
	now := time.Now()

	rows := sqlmock.NewRows([]string{
		"id", "incident_id", "sent_to_staff_ids", "delivery_rule", "sent_at",
		"notification_type", "action_required", "unread_by_staff_ids", "escalated",
	}).
		AddRow("notif-1", incidentID, pq.StringArray{"staff-1"},
			nil, now, nil, true, pq.StringArray{}, false)

	mock.ExpectQuery("SELECT (.+) FROM notifications n WHERE 1=1 AND n.incident_id = (.+) ORDER BY n.sent_at DESC").
		WithArgs(incidentID).
		WillReturnRows(rows)

	// Execute
	notifications, err := GetNotifications(db, nil, &incidentID, false)

	// Assert
	assert.NoError(t, err)
	assert.Len(t, notifications, 1)
	assert.Equal(t, incidentID, notifications[0].IncidentID)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetNotifications_UnreadOnly(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	staffID := "staff-1"
	now := time.Now()

	rows := sqlmock.NewRows([]string{
		"id", "incident_id", "sent_to_staff_ids", "delivery_rule", "sent_at",
		"notification_type", "action_required", "unread_by_staff_ids", "escalated",
	}).
		AddRow("notif-1", "incident-1", pq.StringArray{"staff-1", "staff-2"},
			nil, now, nil, true, pq.StringArray{"staff-1"}, false)

	mock.ExpectQuery("SELECT (.+) FROM notifications n WHERE 1=1 AND (.+) = ANY\\(n.sent_to_staff_ids\\) AND (.+) = ANY\\(n.unread_by_staff_ids\\) ORDER BY n.sent_at DESC").
		WithArgs(staffID, staffID).
		WillReturnRows(rows)

	// Execute
	notifications, err := GetNotifications(db, &staffID, nil, true)

	// Assert
	assert.NoError(t, err)
	assert.Len(t, notifications, 1)
	assert.Contains(t, notifications[0].UnreadByStaffIDs, staffID)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetNotifications_EmptyResult(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	rows := sqlmock.NewRows([]string{
		"id", "incident_id", "sent_to_staff_ids", "delivery_rule", "sent_at",
		"notification_type", "action_required", "unread_by_staff_ids", "escalated",
	})

	mock.ExpectQuery("SELECT (.+) FROM notifications n WHERE 1=1 ORDER BY n.sent_at DESC").
		WillReturnRows(rows)

	// Execute
	notifications, err := GetNotifications(db, nil, nil, false)

	// Assert
	assert.NoError(t, err)
	assert.Empty(t, notifications)
	assert.NoError(t, mock.ExpectationsWereMet())
}

// ==================== CreateNotification Tests ====================

func TestCreateNotification_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	actionRequired := true
	input := NotificationCreate{
		IncidentID:     "incident-1",
		SentToStaffIDs: []string{"staff-1"},
		ActionRequired: &actionRequired,
	}

	now := time.Now()

	// Expect transaction begin
	mock.ExpectBegin()

	// Expect notification insert
	notifRows := sqlmock.NewRows([]string{
		"id", "incident_id", "sent_to_staff_ids", "delivery_rule", "sent_at",
		"notification_type", "action_required", "unread_by_staff_ids", "escalated",
	}).
		AddRow("new-notif-id", input.IncidentID, pq.StringArray(input.SentToStaffIDs),
			nil, now, nil, true, pq.StringArray(input.SentToStaffIDs), false)

	mock.ExpectQuery("INSERT INTO notifications (.+) RETURNING (.+)").
		WithArgs(input.IncidentID, pq.Array(input.SentToStaffIDs), input.NotificationType,
			input.DeliveryRule, true).
		WillReturnRows(notifRows)

	// Expect notification history insert (false is hardcoded in SQL, not a parameter)
	mock.ExpectExec("INSERT INTO notification_histories (.+)").
		WithArgs("new-notif-id", "staff-1").
		WillReturnResult(sqlmock.NewResult(1, 1))

	// Expect transaction commit
	mock.ExpectCommit()

	// Execute
	notification, err := CreateNotification(db, input)

	// Assert
	assert.NoError(t, err)
	assert.NotNil(t, notification)
	assert.Equal(t, "new-notif-id", notification.ID)
	assert.Equal(t, input.IncidentID, notification.IncidentID)
	assert.True(t, notification.ActionRequired)
	assert.Len(t, notification.SentToStaffIDs, 1)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestCreateNotification_MultipleStaffs(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	actionRequired := true
	input := NotificationCreate{
		IncidentID:     "incident-1",
		SentToStaffIDs: []string{"staff-1", "staff-2", "staff-3"},
		ActionRequired: &actionRequired,
	}

	now := time.Now()

	// Expect transaction begin
	mock.ExpectBegin()

	// Expect notification insert
	notifRows := sqlmock.NewRows([]string{
		"id", "incident_id", "sent_to_staff_ids", "delivery_rule", "sent_at",
		"notification_type", "action_required", "unread_by_staff_ids", "escalated",
	}).
		AddRow("new-notif-id", input.IncidentID, pq.StringArray(input.SentToStaffIDs),
			nil, now, nil, true, pq.StringArray(input.SentToStaffIDs), false)

	mock.ExpectQuery("INSERT INTO notifications (.+) RETURNING (.+)").
		WithArgs(input.IncidentID, pq.Array(input.SentToStaffIDs), input.NotificationType,
			input.DeliveryRule, true).
		WillReturnRows(notifRows)

	// Expect notification history inserts for each staff (false is hardcoded in SQL, not a parameter)
	for _, staffID := range input.SentToStaffIDs {
		mock.ExpectExec("INSERT INTO notification_histories (.+)").
			WithArgs("new-notif-id", staffID).
			WillReturnResult(sqlmock.NewResult(1, 1))
	}

	// Expect transaction commit
	mock.ExpectCommit()

	// Execute
	notification, err := CreateNotification(db, input)

	// Assert
	assert.NoError(t, err)
	assert.NotNil(t, notification)
	assert.Len(t, notification.SentToStaffIDs, 3)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestCreateNotification_TransactionRollback(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	actionRequired := true
	input := NotificationCreate{
		IncidentID:     "incident-1",
		SentToStaffIDs: []string{"staff-1"},
		ActionRequired: &actionRequired,
	}

	// Expect transaction begin
	mock.ExpectBegin()

	// Expect notification insert to fail
	mock.ExpectQuery("INSERT INTO notifications (.+) RETURNING (.+)").
		WithArgs(input.IncidentID, pq.Array(input.SentToStaffIDs), input.NotificationType,
			input.DeliveryRule, true).
		WillReturnError(sql.ErrConnDone)

	// Expect rollback
	mock.ExpectRollback()

	// Execute
	notification, err := CreateNotification(db, input)

	// Assert
	assert.Error(t, err)
	assert.Nil(t, notification)
	assert.Equal(t, sql.ErrConnDone, err)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestCreateNotification_DatabaseError(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	input := NotificationCreate{
		IncidentID:     "incident-1",
		SentToStaffIDs: []string{"staff-1"},
	}

	// Expect transaction begin to fail
	mock.ExpectBegin().WillReturnError(sql.ErrConnDone)

	// Execute
	notification, err := CreateNotification(db, input)

	// Assert
	assert.Error(t, err)
	assert.Nil(t, notification)
	assert.Equal(t, sql.ErrConnDone, err)
	assert.NoError(t, mock.ExpectationsWereMet())
}

// ==================== MarkNotificationAsRead Tests ====================

func TestMarkNotificationAsRead_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	notificationID := "notif-1"
	staffID := "staff-1"

	// Expect transaction begin
	mock.ExpectBegin()

	// Expect notification history update
	mock.ExpectExec("UPDATE notification_histories SET read = true, read_at = CURRENT_TIMESTAMP WHERE notification_id = (.+) AND staff_id = (.+)").
		WithArgs(notificationID, staffID).
		WillReturnResult(sqlmock.NewResult(1, 1))

	// Expect notification unread array update
	mock.ExpectExec("UPDATE notifications SET unread_by_staff_ids = array_remove\\(unread_by_staff_ids, (.+)\\) WHERE id = (.+)").
		WithArgs(staffID, notificationID).
		WillReturnResult(sqlmock.NewResult(1, 1))

	// Expect transaction commit
	mock.ExpectCommit()

	// Execute
	err = MarkNotificationAsRead(db, notificationID, staffID)

	// Assert
	assert.NoError(t, err)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestMarkNotificationAsRead_NotFound(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	notificationID := "non-existent-id"
	staffID := "staff-1"

	// Expect transaction begin
	mock.ExpectBegin()

	// Expect notification history update (no rows affected)
	mock.ExpectExec("UPDATE notification_histories SET read = true, read_at = CURRENT_TIMESTAMP WHERE notification_id = (.+) AND staff_id = (.+)").
		WithArgs(notificationID, staffID).
		WillReturnResult(sqlmock.NewResult(0, 0))

	// Expect notification unread array update
	mock.ExpectExec("UPDATE notifications SET unread_by_staff_ids = array_remove\\(unread_by_staff_ids, (.+)\\) WHERE id = (.+)").
		WithArgs(staffID, notificationID).
		WillReturnResult(sqlmock.NewResult(0, 0))

	// Expect transaction commit
	mock.ExpectCommit()

	// Execute
	err = MarkNotificationAsRead(db, notificationID, staffID)

	// Assert
	// Note: Current implementation doesn't return error for 0 rows
	assert.NoError(t, err)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestMarkNotificationAsRead_DatabaseError(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	notificationID := "notif-1"
	staffID := "staff-1"

	// Expect transaction begin
	mock.ExpectBegin()

	// Expect notification history update to fail
	mock.ExpectExec("UPDATE notification_histories SET read = true, read_at = CURRENT_TIMESTAMP WHERE notification_id = (.+) AND staff_id = (.+)").
		WithArgs(notificationID, staffID).
		WillReturnError(sql.ErrConnDone)

	// Expect rollback
	mock.ExpectRollback()

	// Execute
	err = MarkNotificationAsRead(db, notificationID, staffID)

	// Assert
	assert.Error(t, err)
	assert.Equal(t, sql.ErrConnDone, err)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestMarkNotificationAsRead_UpdateUnreadArray(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	notificationID := "notif-1"
	staffID := "staff-2"

	// Expect transaction begin
	mock.ExpectBegin()

	// Expect notification history update
	mock.ExpectExec("UPDATE notification_histories SET read = true, read_at = CURRENT_TIMESTAMP WHERE notification_id = (.+) AND staff_id = (.+)").
		WithArgs(notificationID, staffID).
		WillReturnResult(sqlmock.NewResult(1, 1))

	// Expect notification unread array update - this should remove staff-2 from the array
	mock.ExpectExec("UPDATE notifications SET unread_by_staff_ids = array_remove\\(unread_by_staff_ids, (.+)\\) WHERE id = (.+)").
		WithArgs(staffID, notificationID).
		WillReturnResult(sqlmock.NewResult(1, 1))

	// Expect transaction commit
	mock.ExpectCommit()

	// Execute
	err = MarkNotificationAsRead(db, notificationID, staffID)

	// Assert
	assert.NoError(t, err)
	assert.NoError(t, mock.ExpectationsWereMet())
}

// ==================== EscalateNotification Tests ====================

func TestEscalateNotification_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	notificationID := "notif-1"
	incidentID := "incident-1"

	// Expect transaction begin
	mock.ExpectBegin()

	// Expect notification escalation update
	mock.ExpectExec("UPDATE notifications SET escalated = true, updated_at = CURRENT_TIMESTAMP WHERE id = (.+)").
		WithArgs(notificationID).
		WillReturnResult(sqlmock.NewResult(1, 1))

	// Expect incident ID query
	incidentRows := sqlmock.NewRows([]string{"incident_id"}).
		AddRow(incidentID)
	mock.ExpectQuery("SELECT incident_id FROM notifications WHERE id = (.+)").
		WithArgs(notificationID).
		WillReturnRows(incidentRows)

	// Expect supervisor query
	supervisorRows := sqlmock.NewRows([]string{"id"}).
		AddRow("supervisor-1").
		AddRow("supervisor-2")
	mock.ExpectQuery("SELECT id FROM staffs WHERE role IN (.+) LIMIT 5").
		WillReturnRows(supervisorRows)

	// Expect escalated notification insert
	mock.ExpectExec("INSERT INTO notifications (.+)").
		WithArgs(incidentID, pq.Array([]string{"supervisor-1", "supervisor-2"})).
		WillReturnResult(sqlmock.NewResult(1, 1))

	// Expect transaction commit
	mock.ExpectCommit()

	// Execute
	err = EscalateNotification(db, notificationID)

	// Assert
	assert.NoError(t, err)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestEscalateNotification_NoSupervisors(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	notificationID := "notif-1"
	incidentID := "incident-1"

	// Expect transaction begin
	mock.ExpectBegin()

	// Expect notification escalation update
	mock.ExpectExec("UPDATE notifications SET escalated = true, updated_at = CURRENT_TIMESTAMP WHERE id = (.+)").
		WithArgs(notificationID).
		WillReturnResult(sqlmock.NewResult(1, 1))

	// Expect incident ID query
	incidentRows := sqlmock.NewRows([]string{"incident_id"}).
		AddRow(incidentID)
	mock.ExpectQuery("SELECT incident_id FROM notifications WHERE id = (.+)").
		WithArgs(notificationID).
		WillReturnRows(incidentRows)

	// Expect supervisor query - no supervisors found
	supervisorRows := sqlmock.NewRows([]string{"id"})
	mock.ExpectQuery("SELECT id FROM staffs WHERE role IN (.+) LIMIT 5").
		WillReturnRows(supervisorRows)

	// Expect transaction commit (no escalated notification created)
	mock.ExpectCommit()

	// Execute
	err = EscalateNotification(db, notificationID)

	// Assert
	assert.NoError(t, err)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestEscalateNotification_DatabaseError(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	notificationID := "notif-1"

	// Expect transaction begin
	mock.ExpectBegin()

	// Expect notification escalation update to fail
	mock.ExpectExec("UPDATE notifications SET escalated = true, updated_at = CURRENT_TIMESTAMP WHERE id = (.+)").
		WithArgs(notificationID).
		WillReturnError(sql.ErrConnDone)

	// Expect rollback
	mock.ExpectRollback()

	// Execute
	err = EscalateNotification(db, notificationID)

	// Assert
	assert.Error(t, err)
	assert.Equal(t, sql.ErrConnDone, err)
	assert.NoError(t, mock.ExpectationsWereMet())
}

// ==================== GetNotificationHistories Tests ====================

func TestGetNotificationHistories_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	notificationID := "notif-1"
	now := time.Now()
	readAt := now.Add(1 * time.Hour)

	rows := sqlmock.NewRows([]string{
		"id", "notification_id", "staff_id", "read", "read_at", "escalated", "escalated_at",
	}).
		AddRow("history-1", notificationID, "staff-1", true, &readAt, false, nil).
		AddRow("history-2", notificationID, "staff-2", false, nil, false, nil)

	mock.ExpectQuery("SELECT (.+) FROM notification_histories WHERE notification_id = (.+) ORDER BY created_at DESC").
		WithArgs(notificationID).
		WillReturnRows(rows)

	// Execute
	histories, err := GetNotificationHistories(db, notificationID)

	// Assert
	assert.NoError(t, err)
	assert.Len(t, histories, 2)
	assert.Equal(t, "history-1", histories[0].ID)
	assert.True(t, histories[0].Read)
	assert.NotNil(t, histories[0].ReadAt)
	assert.Equal(t, "history-2", histories[1].ID)
	assert.False(t, histories[1].Read)
	assert.Nil(t, histories[1].ReadAt)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetNotificationHistories_EmptyResult(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	notificationID := "notif-no-history"

	rows := sqlmock.NewRows([]string{
		"id", "notification_id", "staff_id", "read", "read_at", "escalated", "escalated_at",
	})

	mock.ExpectQuery("SELECT (.+) FROM notification_histories WHERE notification_id = (.+) ORDER BY created_at DESC").
		WithArgs(notificationID).
		WillReturnRows(rows)

	// Execute
	histories, err := GetNotificationHistories(db, notificationID)

	// Assert
	assert.NoError(t, err)
	assert.Empty(t, histories)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetNotificationHistories_DatabaseError(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	notificationID := "notif-1"

	mock.ExpectQuery("SELECT (.+) FROM notification_histories WHERE notification_id = (.+) ORDER BY created_at DESC").
		WithArgs(notificationID).
		WillReturnError(sql.ErrConnDone)

	// Execute
	histories, err := GetNotificationHistories(db, notificationID)

	// Assert
	assert.Error(t, err)
	assert.Nil(t, histories)
	assert.Equal(t, sql.ErrConnDone, err)
	assert.NoError(t, mock.ExpectationsWereMet())
}
