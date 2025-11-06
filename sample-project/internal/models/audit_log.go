package models

import (
	"database/sql"
	"time"
)

// AuditLog represents an audit log entry
type AuditLog struct {
	ID         string    `json:"id"`
	Operation  string    `json:"operation"`
	OperatorID *string   `json:"operatorId,omitempty"`
	TargetType *string   `json:"targetType,omitempty"`
	TargetID   *string   `json:"targetId,omitempty"`
	Detail     *string   `json:"detail,omitempty"`
	Timestamp  time.Time `json:"timestamp"`
}

// GetAuditLogs retrieves audit logs with optional filters
func GetAuditLogs(db *sql.DB, targetType, userID, operation *string, from, to *time.Time) ([]AuditLog, error) {
	query := `
		SELECT id, operation, operator_id, target_type, target_id, detail, timestamp
		FROM audit_logs
		WHERE 1=1
	`
	args := []interface{}{}
	argIdx := 1

	if targetType != nil {
		query += ` AND target_type = $` + string(rune('0'+argIdx))
		args = append(args, *targetType)
		argIdx++
	}

	if userID != nil {
		query += ` AND operator_id = $` + string(rune('0'+argIdx))
		args = append(args, *userID)
		argIdx++
	}

	if operation != nil {
		query += ` AND operation = $` + string(rune('0'+argIdx))
		args = append(args, *operation)
		argIdx++
	}

	if from != nil {
		query += ` AND timestamp >= $` + string(rune('0'+argIdx))
		args = append(args, *from)
		argIdx++
	}

	if to != nil {
		query += ` AND timestamp <= $` + string(rune('0'+argIdx))
		args = append(args, *to)
		argIdx++
	}

	query += ` ORDER BY timestamp DESC LIMIT 1000`

	rows, err := db.Query(query, args...)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var logs []AuditLog
	for rows.Next() {
		var log AuditLog
		err := rows.Scan(
			&log.ID,
			&log.Operation,
			&log.OperatorID,
			&log.TargetType,
			&log.TargetID,
			&log.Detail,
			&log.Timestamp,
		)
		if err != nil {
			return nil, err
		}
		logs = append(logs, log)
	}

	return logs, rows.Err()
}

// CreateAuditLog creates a new audit log entry
func CreateAuditLog(db *sql.DB, operation string, operatorID, targetType, targetID, detail *string) error {
	query := `
		INSERT INTO audit_logs (operation, operator_id, target_type, target_id, detail)
		VALUES ($1, $2, $3, $4, $5)
	`

	_, err := db.Exec(query, operation, operatorID, targetType, targetID, detail)
	return err
}

// Configuration represents system configuration
type Configuration struct {
	ID                     string                   `json:"id"`
	AISensitivity          int                      `json:"aiSensitivity"`
	VideoRetentionDays     int                      `json:"videoRetentionDays"`
	NotificationRules      []map[string]interface{} `json:"notificationRules,omitempty"`
	NotificationTimeoutSec int                      `json:"notificationTimeoutSec"`
	CameraOnOffConfig      []map[string]interface{} `json:"cameraOnOffConfig,omitempty"`
	AreaConfig             []map[string]interface{} `json:"areaConfig,omitempty"`
	LastUpdated            time.Time                `json:"lastUpdated"`
	UpdatedBy              *string                  `json:"updatedBy,omitempty"`
}

// ConfigurationUpdate represents the input for updating configuration
type ConfigurationUpdate struct {
	AISensitivity          *int                      `json:"aiSensitivity,omitempty"`
	VideoRetentionDays     *int                      `json:"videoRetentionDays,omitempty"`
	NotificationRules      *[]map[string]interface{} `json:"notificationRules,omitempty"`
	NotificationTimeoutSec *int                      `json:"notificationTimeoutSec,omitempty"`
	CameraOnOffConfig      *[]map[string]interface{} `json:"cameraOnOffConfig,omitempty"`
	AreaConfig             *[]map[string]interface{} `json:"areaConfig,omitempty"`
}

// GetConfiguration retrieves the system configuration
func GetConfiguration(db *sql.DB) (*Configuration, error) {
	query := `
		SELECT id, ai_sensitivity, video_retention_days, notification_rules,
		       notification_timeout_sec, camera_on_off_config, area_config,
		       last_updated, updated_by
		FROM configurations
		LIMIT 1
	`

	var config Configuration
	var notificationRulesJSON, cameraConfigJSON, areaConfigJSON []byte

	err := db.QueryRow(query).Scan(
		&config.ID,
		&config.AISensitivity,
		&config.VideoRetentionDays,
		&notificationRulesJSON,
		&config.NotificationTimeoutSec,
		&cameraConfigJSON,
		&areaConfigJSON,
		&config.LastUpdated,
		&config.UpdatedBy,
	)

	if err == sql.ErrNoRows {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}

	// Parse JSON fields (simplified - in production use proper JSON unmarshaling)
	// For now, return empty arrays
	config.NotificationRules = []map[string]interface{}{}
	config.CameraOnOffConfig = []map[string]interface{}{}
	config.AreaConfig = []map[string]interface{}{}

	return &config, nil
}

// UpdateConfiguration updates the system configuration
func UpdateConfiguration(db *sql.DB, input ConfigurationUpdate, updatedBy string) (*Configuration, error) {
	updateFields := []string{}
	args := []interface{}{}
	argIdx := 1

	if input.AISensitivity != nil {
		updateFields = append(updateFields, "ai_sensitivity = $"+string(rune('0'+argIdx)))
		args = append(args, *input.AISensitivity)
		argIdx++
	}

	if input.VideoRetentionDays != nil {
		updateFields = append(updateFields, "video_retention_days = $"+string(rune('0'+argIdx)))
		args = append(args, *input.VideoRetentionDays)
		argIdx++
	}

	if input.NotificationTimeoutSec != nil {
		updateFields = append(updateFields, "notification_timeout_sec = $"+string(rune('0'+argIdx)))
		args = append(args, *input.NotificationTimeoutSec)
		argIdx++
	}

	if len(updateFields) == 0 {
		// No fields to update, return current configuration
		return GetConfiguration(db)
	}

	// Always update last_updated and updated_by
	updateFields = append(updateFields, "last_updated = CURRENT_TIMESTAMP")
	updateFields = append(updateFields, "updated_by = $"+string(rune('0'+argIdx)))
	args = append(args, updatedBy)

	query := `UPDATE configurations SET ` + updateFields[0]
	for i := 1; i < len(updateFields); i++ {
		query += ", " + updateFields[i]
	}

	_, err := db.Exec(query, args...)
	if err != nil {
		return nil, err
	}

	return GetConfiguration(db)
}
