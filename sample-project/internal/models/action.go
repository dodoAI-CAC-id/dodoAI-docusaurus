package models

import (
	"database/sql"
	"time"
)

// Action represents an action/response to an incident
type Action struct {
	ID         string     `json:"id"`
	IncidentID string     `json:"incidentId"`
	StaffID    string     `json:"staffId"`
	ActionType string     `json:"actionType"`
	Progress   string     `json:"progress"`
	StartAt    time.Time  `json:"startAt"`
	EndAt      *time.Time `json:"endAt,omitempty"`
	Note       *string    `json:"note,omitempty"`
	CreatedAt  time.Time  `json:"createdAt"`
}

// ActionCreate represents the input for creating an action
type ActionCreate struct {
	StaffID    string  `json:"staffId" binding:"required"`
	ActionType string  `json:"actionType" binding:"required"`
	Note       *string `json:"note,omitempty"`
}

// ActionWithDetails extends Action with additional context
type ActionWithDetails struct {
	Action
	RoomBedNameOrNumber   string `json:"roomBedNameOrNumber"`
	PersonName            string `json:"personName"`
	IncidentDetectionType string `json:"incidentDetectionType"`
}

// GetActionsByIncidentID retrieves all actions for an incident
func GetActionsByIncidentID(db *sql.DB, incidentID string) ([]Action, error) {
	query := `
		SELECT id, incident_id, staff_id, action_type, progress, start_at, end_at, note, created_at
		FROM actions
		WHERE incident_id = $1
		ORDER BY created_at DESC
	`

	rows, err := db.Query(query, incidentID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var actions []Action
	for rows.Next() {
		var action Action
		err := rows.Scan(
			&action.ID,
			&action.IncidentID,
			&action.StaffID,
			&action.ActionType,
			&action.Progress,
			&action.StartAt,
			&action.EndAt,
			&action.Note,
			&action.CreatedAt,
		)
		if err != nil {
			return nil, err
		}
		actions = append(actions, action)
	}

	return actions, rows.Err()
}

// GetActionsWithDetailsByIncidentID retrieves actions with additional context
func GetActionsWithDetailsByIncidentID(db *sql.DB, incidentID string) ([]ActionWithDetails, error) {
	query := `
		SELECT 
			a.id, a.incident_id, a.staff_id, a.action_type, a.progress, 
			a.start_at, a.end_at, a.note, a.created_at,
			COALESCE(r.room_number, 'N/A') as room_bed,
			COALESCE(p.name, 'N/A') as person_name,
			i.type as incident_type
		FROM actions a
		JOIN incidents i ON a.incident_id = i.id
		LEFT JOIN persons p ON i.person_id = p.id
		LEFT JOIN rooms r ON i.room_id = r.id
		WHERE a.incident_id = $1
		ORDER BY a.created_at DESC
	`

	rows, err := db.Query(query, incidentID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var actions []ActionWithDetails
	for rows.Next() {
		var action ActionWithDetails
		err := rows.Scan(
			&action.ID,
			&action.IncidentID,
			&action.StaffID,
			&action.ActionType,
			&action.Progress,
			&action.StartAt,
			&action.EndAt,
			&action.Note,
			&action.CreatedAt,
			&action.RoomBedNameOrNumber,
			&action.PersonName,
			&action.IncidentDetectionType,
		)
		if err != nil {
			return nil, err
		}
		actions = append(actions, action)
	}

	return actions, rows.Err()
}

// CreateAction creates a new action for an incident
func CreateAction(db *sql.DB, incidentID string, input ActionCreate) (*Action, error) {
	// Determine progress based on action type
	progress := "in_progress"
	if input.ActionType == "complete" {
		progress = "completed"
	}

	query := `
		INSERT INTO actions (incident_id, staff_id, action_type, progress, note)
		VALUES ($1, $2, $3, $4, $5)
		RETURNING id, incident_id, staff_id, action_type, progress, start_at, end_at, note, created_at
	`

	var action Action
	err := db.QueryRow(
		query,
		incidentID,
		input.StaffID,
		input.ActionType,
		progress,
		input.Note,
	).Scan(
		&action.ID,
		&action.IncidentID,
		&action.StaffID,
		&action.ActionType,
		&action.Progress,
		&action.StartAt,
		&action.EndAt,
		&action.Note,
		&action.CreatedAt,
	)

	if err != nil {
		return nil, err
	}

	// If action type is complete, update end_at
	if input.ActionType == "complete" {
		updateQuery := `
			UPDATE actions
			SET end_at = CURRENT_TIMESTAMP, progress = 'completed'
			WHERE id = $1
		`
		_, err = db.Exec(updateQuery, action.ID)
		if err != nil {
			return nil, err
		}

		// Also update incident status if completing
		incidentUpdateQuery := `
			UPDATE incidents
			SET status = 'resolved'
			WHERE id = $1 AND status != 'resolved'
		`
		_, err = db.Exec(incidentUpdateQuery, incidentID)
		if err != nil {
			return nil, err
		}
	}

	return &action, nil
}

// UpdateActionProgress updates the progress of an action
func UpdateActionProgress(db *sql.DB, actionID, progress string) error {
	query := `
		UPDATE actions
		SET progress = $1
	`
	args := []interface{}{progress}
	argIdx := 2

	if progress == "completed" {
		query += `, end_at = CURRENT_TIMESTAMP`
	}

	query += ` WHERE id = $` + string(rune('0'+argIdx))
	args = append(args, actionID)

	_, err := db.Exec(query, args...)
	return err
}
