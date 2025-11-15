package models

import (
	"database/sql"
	"encoding/json"
	"time"

	"github.com/lib/pq"
)

// Incident represents an incident event in the system
type Incident struct {
	ID              string          `json:"id"`
	DetectedAt      time.Time       `json:"detectedAt"`
	Type            string          `json:"type"`
	Status          string          `json:"status"`
	PersonID        *string         `json:"personId,omitempty"`
	CameraID        *string         `json:"cameraId,omitempty"`
	RoomID          *string         `json:"roomId,omitempty"`
	DetectionAreaID *string         `json:"detectionAreaId,omitempty"`
	Description     *string         `json:"description,omitempty"`
	CreatedBy       *string         `json:"createdBy,omitempty"`
	CreatedAt       time.Time       `json:"createdAt"`
	UpdatedAt       time.Time       `json:"updatedAt"`
	
	// Display fields (populated via JOIN)
	PersonName      *string         `json:"personName,omitempty"`
	RoomNumber      *string         `json:"roomNumber,omitempty"`
	
	// Response information (from actions table)
	AssignedTo             *string    `json:"assignedTo,omitempty"`
	ActionType             *string    `json:"actionType,omitempty"`
	ResponseStartedAt      *time.Time `json:"responseStartedAt,omitempty"`
	ResponseCompletedAt    *time.Time `json:"responseCompletedAt,omitempty"`
	
	// Alert status
	IsAlertActive   bool           `json:"isAlertActive"`
	
	Notifications   []Notification  `json:"notifications,omitempty"`
	Actions         []Action        `json:"actions,omitempty"`
	Videos          []IncidentVideo `json:"videos,omitempty"`
}

// IncidentCreate represents the input for creating a new incident
type IncidentCreate struct {
	DetectedAt      time.Time `json:"detectedAt"`
	Type            string    `json:"type"`
	PersonID        string    `json:"personId"`
	CameraID        string    `json:"cameraId"`
	RoomID          *string   `json:"roomId,omitempty"`
	DetectionAreaID *string   `json:"detectionAreaId,omitempty"`
	Description     *string   `json:"description,omitempty"`
}

// IncidentUpdate represents the input for updating an incident
type IncidentUpdate struct {
	Status          *string `json:"status,omitempty"`
	Description     *string `json:"description,omitempty"`
	DetectionAreaID *string `json:"detectionAreaId,omitempty"`
}

// IncidentWithPictures extends Incident with detection pictures
type IncidentWithPictures struct {
	Incident
	Pictures *IncidentPictures `json:"pictures,omitempty"`
}

// IncidentPictures contains base64 encoded detection pictures
type IncidentPictures struct {
	PictureAtDetection     *string `json:"pictureAtDetection,omitempty"`
	PictureBeforeDetection *string `json:"pictureBeforeDetection,omitempty"`
}

// GetAllIncidents retrieves incidents with optional filters
func GetAllIncidents(db *sql.DB, personID, status *string, from, to *time.Time) ([]Incident, error) {
	query := `
		SELECT 
			i.id, i.detected_at, i.type, i.status, 
			i.person_id, i.camera_id, i.room_id, 
			i.detection_area_id, i.description, i.created_by, 
			i.created_at, i.updated_at,
			p.name as person_name,
			r.room_number as room_number,
			first_action.staff_name as assigned_to,
			first_action.action_type as action_type,
			first_action.start_at as response_started_at,
			last_action.end_at as response_completed_at,
			i.alert_active
		FROM incidents i
		LEFT JOIN persons p ON i.person_id = p.id
		LEFT JOIN rooms r ON i.room_id = r.id
		LEFT JOIN LATERAL (
			SELECT s.name as staff_name, a.action_type, a.start_at
			FROM actions a
			JOIN staffs s ON a.staff_id = s.id
			WHERE a.incident_id = i.id
			ORDER BY a.created_at ASC
			LIMIT 1
		) first_action ON true
		LEFT JOIN LATERAL (
			SELECT a.end_at
			FROM actions a
			WHERE a.incident_id = i.id AND a.end_at IS NOT NULL
			ORDER BY a.created_at DESC
			LIMIT 1
		) last_action ON true
		WHERE 1=1
	`
	args := []interface{}{}
	argIdx := 1

	if personID != nil {
		query += ` AND i.person_id = $` + string(rune('0'+argIdx))
		args = append(args, *personID)
		argIdx++
	}

	if status != nil {
		query += ` AND i.status = $` + string(rune('0'+argIdx))
		args = append(args, *status)
		argIdx++
	}

	if from != nil {
		query += ` AND i.detected_at >= $` + string(rune('0'+argIdx))
		args = append(args, *from)
		argIdx++
	}

	if to != nil {
		query += ` AND i.detected_at <= $` + string(rune('0'+argIdx))
		args = append(args, *to)
		argIdx++
	}

	query += ` ORDER BY i.detected_at DESC`

	rows, err := db.Query(query, args...)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var incidents []Incident
	for rows.Next() {
		var incident Incident
		err := rows.Scan(
			&incident.ID,
			&incident.DetectedAt,
			&incident.Type,
			&incident.Status,
			&incident.PersonID,
			&incident.CameraID,
			&incident.RoomID,
			&incident.DetectionAreaID,
			&incident.Description,
			&incident.CreatedBy,
			&incident.CreatedAt,
			&incident.UpdatedAt,
			&incident.PersonName,
			&incident.RoomNumber,
			&incident.AssignedTo,
			&incident.ActionType,
			&incident.ResponseStartedAt,
			&incident.ResponseCompletedAt,
			&incident.IsAlertActive,
		)
		if err != nil {
			return nil, err
		}
		incidents = append(incidents, incident)
	}

	return incidents, rows.Err()
}

// GetIncidentByID retrieves a specific incident with related data
func GetIncidentByID(db *sql.DB, id string) (*Incident, error) {
	query := `
		SELECT 
			i.id, i.detected_at, i.type, i.status, 
			i.person_id, i.camera_id, i.room_id,
			i.detection_area_id, i.description, i.created_by, 
			i.created_at, i.updated_at,
			p.name as person_name,
			r.room_number as room_number,
			i.alert_active
		FROM incidents i
		LEFT JOIN persons p ON i.person_id = p.id
		LEFT JOIN rooms r ON i.room_id = r.id
		WHERE i.id = $1
	`

	var incident Incident
	err := db.QueryRow(query, id).Scan(
		&incident.ID,
		&incident.DetectedAt,
		&incident.Type,
		&incident.Status,
		&incident.PersonID,
		&incident.CameraID,
		&incident.RoomID,
		&incident.DetectionAreaID,
		&incident.Description,
		&incident.CreatedBy,
		&incident.CreatedAt,
		&incident.UpdatedAt,
		&incident.PersonName,
		&incident.RoomNumber,
		&incident.IsAlertActive,
	)

	if err == sql.ErrNoRows {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}

	// Load related notifications
	notifications, err := GetNotificationsByIncidentID(db, id)
	if err != nil {
		return nil, err
	}
	incident.Notifications = notifications

	// Load related actions
	actions, err := GetActionsByIncidentID(db, id)
	if err != nil {
		return nil, err
	}
	incident.Actions = actions

	// Load related videos
	videos, err := GetVideosByIncidentID(db, id)
	if err != nil {
		return nil, err
	}
	incident.Videos = videos

	return &incident, nil
}

// CreateIncident creates a new incident and optionally triggers a notification
func CreateIncident(db *sql.DB, input IncidentCreate) (*Incident, error) {
	tx, err := db.Begin()
	if err != nil {
		return nil, err
	}
	defer tx.Rollback()

	query := `
		INSERT INTO incidents (detected_at, type, status, person_id, camera_id, room_id, detection_area_id, description)
		VALUES ($1, $2, 'open', $3, $4, $5, $6, $7)
		RETURNING id, detected_at, type, status, person_id, camera_id, room_id, 
		          detection_area_id, description, created_by, created_at, updated_at
	`

	var incident Incident
	err = tx.QueryRow(
		query,
		input.DetectedAt,
		input.Type,
		input.PersonID,
		input.CameraID,
		input.RoomID,
		input.DetectionAreaID,
		input.Description,
	).Scan(
		&incident.ID,
		&incident.DetectedAt,
		&incident.Type,
		&incident.Status,
		&incident.PersonID,
		&incident.CameraID,
		&incident.RoomID,
		&incident.DetectionAreaID,
		&incident.Description,
		&incident.CreatedBy,
		&incident.CreatedAt,
		&incident.UpdatedAt,
	)

	if err != nil {
		return nil, err
	}

	// Auto-create notification for the incident
	// Get active staff members for notification
	staffQuery := `SELECT id FROM staffs WHERE role IN ('care', 'nurse') LIMIT 10`
	staffRows, err := tx.Query(staffQuery)
	if err != nil {
		return nil, err
	}
	defer staffRows.Close()

	var staffIDs []string
	for staffRows.Next() {
		var staffID string
		if err := staffRows.Scan(&staffID); err != nil {
			return nil, err
		}
		staffIDs = append(staffIDs, staffID)
	}

	if len(staffIDs) > 0 {
		notificationQuery := `
			INSERT INTO notifications (incident_id, sent_to_staff_ids, notification_type, action_required, unread_by_staff_ids)
			VALUES ($1, $2, 'incident_detected', true, $2)
		`
		_, err = tx.Exec(notificationQuery, incident.ID, pq.Array(staffIDs))
		if err != nil {
			return nil, err
		}

		// Create notification histories for each staff
		for _, staffID := range staffIDs {
			historyQuery := `
				INSERT INTO notification_histories (notification_id, staff_id, read)
				SELECT id, $1, false FROM notifications WHERE incident_id = $2
			`
			_, err = tx.Exec(historyQuery, staffID, incident.ID)
			if err != nil {
				return nil, err
			}
		}
	}

	if err := tx.Commit(); err != nil {
		return nil, err
	}

	return &incident, nil
}

// UpdateIncident updates an existing incident
func UpdateIncident(db *sql.DB, id string, input IncidentUpdate) (*Incident, error) {
	// Build dynamic update query
	updateFields := []string{}
	args := []interface{}{}
	argIdx := 1

	if input.Status != nil {
		updateFields = append(updateFields, "status = $"+string(rune('0'+argIdx)))
		args = append(args, *input.Status)
		argIdx++
	}

	if input.Description != nil {
		updateFields = append(updateFields, "description = $"+string(rune('0'+argIdx)))
		args = append(args, *input.Description)
		argIdx++
	}

	if input.DetectionAreaID != nil {
		updateFields = append(updateFields, "detection_area_id = $"+string(rune('0'+argIdx)))
		args = append(args, *input.DetectionAreaID)
		argIdx++
	}

	if len(updateFields) == 0 {
		// No fields to update, return current incident
		return GetIncidentByID(db, id)
	}

	query := `
		UPDATE incidents
		SET ` + updateFields[0]
	for i := 1; i < len(updateFields); i++ {
		query += ", " + updateFields[i]
	}
	query += `, updated_at = CURRENT_TIMESTAMP
		WHERE id = $` + string(rune('0'+argIdx)) + `
		RETURNING id, detected_at, type, status, person_id, camera_id, room_id,
		          detection_area_id, description, created_by, created_at, updated_at
	`
	args = append(args, id)

	var incident Incident
	err := db.QueryRow(query, args...).Scan(
		&incident.ID,
		&incident.DetectedAt,
		&incident.Type,
		&incident.Status,
		&incident.PersonID,
		&incident.CameraID,
		&incident.RoomID,
		&incident.DetectionAreaID,
		&incident.Description,
		&incident.CreatedBy,
		&incident.CreatedAt,
		&incident.UpdatedAt,
	)

	if err == sql.ErrNoRows {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}

	return &incident, nil
}

// ToggleAlertStatus updates the alert_active status of an incident
func ToggleAlertStatus(db *sql.DB, id string, isActive bool) (*Incident, error) {
	query := `
		UPDATE incidents
		SET alert_active = $1, updated_at = CURRENT_TIMESTAMP
		WHERE id = $2
		RETURNING id, detected_at, type, status, person_id, camera_id, room_id,
		          detection_area_id, description, created_by, created_at, updated_at, alert_active
	`

	var incident Incident
	err := db.QueryRow(query, isActive, id).Scan(
		&incident.ID,
		&incident.DetectedAt,
		&incident.Type,
		&incident.Status,
		&incident.PersonID,
		&incident.CameraID,
		&incident.RoomID,
		&incident.DetectionAreaID,
		&incident.Description,
		&incident.CreatedBy,
		&incident.CreatedAt,
		&incident.UpdatedAt,
		&incident.IsAlertActive,
	)

	if err == sql.ErrNoRows {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}

	// Fetch display fields via JOIN
	displayQuery := `
		SELECT p.name as person_name, r.room_number as room_number
		FROM incidents i
		LEFT JOIN persons p ON i.person_id = p.id
		LEFT JOIN rooms r ON i.room_id = r.id
		WHERE i.id = $1
	`
	
	err = db.QueryRow(displayQuery, id).Scan(&incident.PersonName, &incident.RoomNumber)
	if err != nil && err != sql.ErrNoRows {
		return nil, err
	}

	return &incident, nil
}

// GetIncidentPictures retrieves detection pictures for an incident (placeholder)
// In a real implementation, this would fetch from file storage or database
func GetIncidentPictures(db *sql.DB, incidentID string) (*IncidentPictures, error) {
	// Placeholder implementation
	// In production, this would retrieve actual images from storage
	return &IncidentPictures{
		PictureAtDetection:     nil,
		PictureBeforeDetection: nil,
	}, nil
}

// Helper function to marshal JSON for arrays
func jsonMarshal(v interface{}) ([]byte, error) {
	return json.Marshal(v)
}
