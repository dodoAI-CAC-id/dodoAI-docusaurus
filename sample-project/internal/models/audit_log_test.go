package models

import (
	"database/sql"
	"testing"
	"time"

	"github.com/DATA-DOG/go-sqlmock"
	"github.com/stretchr/testify/assert"
)

// ==================== GetAuditLogs Tests ====================

func TestGetAuditLogs_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	now := time.Now()
	operatorID := "user-1"
	targetType := "incident"
	targetID := "incident-1"
	detail := "Created new incident"

	rows := sqlmock.NewRows([]string{
		"id", "operation", "operator_id", "target_type", "target_id", "detail", "timestamp",
	}).
		AddRow("log-1", "create", &operatorID, &targetType, &targetID, &detail, now).
		AddRow("log-2", "update", &operatorID, &targetType, &targetID, nil, now)

	mock.ExpectQuery("SELECT (.+) FROM audit_logs WHERE 1=1 ORDER BY timestamp DESC LIMIT 1000").
		WillReturnRows(rows)

	// Execute
	logs, err := GetAuditLogs(db, nil, nil, nil, nil, nil)

	// Assert
	assert.NoError(t, err)
	assert.Len(t, logs, 2)
	assert.Equal(t, "log-1", logs[0].ID)
	assert.Equal(t, "create", logs[0].Operation)
	assert.NotNil(t, logs[0].OperatorID)
	assert.Equal(t, operatorID, *logs[0].OperatorID)
	assert.NotNil(t, logs[0].TargetType)
	assert.Equal(t, targetType, *logs[0].TargetType)
	assert.NotNil(t, logs[0].Detail)
	assert.Equal(t, detail, *logs[0].Detail)

	assert.Equal(t, "log-2", logs[1].ID)
	assert.Equal(t, "update", logs[1].Operation)
	assert.Nil(t, logs[1].Detail)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetAuditLogs_FilterByTargetType(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	targetType := "incident"
	now := time.Now()

	rows := sqlmock.NewRows([]string{
		"id", "operation", "operator_id", "target_type", "target_id", "detail", "timestamp",
	}).
		AddRow("log-1", "create", nil, &targetType, nil, nil, now)

	mock.ExpectQuery("SELECT (.+) FROM audit_logs WHERE 1=1 AND target_type = (.+) ORDER BY timestamp DESC LIMIT 1000").
		WithArgs(targetType).
		WillReturnRows(rows)

	// Execute
	logs, err := GetAuditLogs(db, &targetType, nil, nil, nil, nil)

	// Assert
	assert.NoError(t, err)
	assert.Len(t, logs, 1)
	assert.NotNil(t, logs[0].TargetType)
	assert.Equal(t, targetType, *logs[0].TargetType)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetAuditLogs_FilterByOperatorID(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	userID := "user-1"
	now := time.Now()

	rows := sqlmock.NewRows([]string{
		"id", "operation", "operator_id", "target_type", "target_id", "detail", "timestamp",
	}).
		AddRow("log-1", "update", &userID, nil, nil, nil, now)

	mock.ExpectQuery("SELECT (.+) FROM audit_logs WHERE 1=1 AND operator_id = (.+) ORDER BY timestamp DESC LIMIT 1000").
		WithArgs(userID).
		WillReturnRows(rows)

	// Execute
	logs, err := GetAuditLogs(db, nil, &userID, nil, nil, nil)

	// Assert
	assert.NoError(t, err)
	assert.Len(t, logs, 1)
	assert.NotNil(t, logs[0].OperatorID)
	assert.Equal(t, userID, *logs[0].OperatorID)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetAuditLogs_FilterByOperation(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	operation := "delete"
	now := time.Now()

	rows := sqlmock.NewRows([]string{
		"id", "operation", "operator_id", "target_type", "target_id", "detail", "timestamp",
	}).
		AddRow("log-1", operation, nil, nil, nil, nil, now)

	mock.ExpectQuery("SELECT (.+) FROM audit_logs WHERE 1=1 AND operation = (.+) ORDER BY timestamp DESC LIMIT 1000").
		WithArgs(operation).
		WillReturnRows(rows)

	// Execute
	logs, err := GetAuditLogs(db, nil, nil, &operation, nil, nil)

	// Assert
	assert.NoError(t, err)
	assert.Len(t, logs, 1)
	assert.Equal(t, operation, logs[0].Operation)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetAuditLogs_FilterByTimeRange(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	from := time.Now().Add(-24 * time.Hour)
	to := time.Now()
	now := time.Now()

	rows := sqlmock.NewRows([]string{
		"id", "operation", "operator_id", "target_type", "target_id", "detail", "timestamp",
	}).
		AddRow("log-1", "create", nil, nil, nil, nil, now)

	mock.ExpectQuery("SELECT (.+) FROM audit_logs WHERE 1=1 AND timestamp >= (.+) AND timestamp <= (.+) ORDER BY timestamp DESC LIMIT 1000").
		WithArgs(from, to).
		WillReturnRows(rows)

	// Execute
	logs, err := GetAuditLogs(db, nil, nil, nil, &from, &to)

	// Assert
	assert.NoError(t, err)
	assert.Len(t, logs, 1)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetAuditLogs_EmptyResult(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	rows := sqlmock.NewRows([]string{
		"id", "operation", "operator_id", "target_type", "target_id", "detail", "timestamp",
	})

	mock.ExpectQuery("SELECT (.+) FROM audit_logs WHERE 1=1 ORDER BY timestamp DESC LIMIT 1000").
		WillReturnRows(rows)

	// Execute
	logs, err := GetAuditLogs(db, nil, nil, nil, nil, nil)

	// Assert
	assert.NoError(t, err)
	assert.Empty(t, logs)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetAuditLogs_DatabaseError(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	mock.ExpectQuery("SELECT (.+) FROM audit_logs WHERE 1=1 ORDER BY timestamp DESC LIMIT 1000").
		WillReturnError(sql.ErrConnDone)

	// Execute
	logs, err := GetAuditLogs(db, nil, nil, nil, nil, nil)

	// Assert
	assert.Error(t, err)
	assert.Nil(t, logs)
	assert.Equal(t, sql.ErrConnDone, err)
	assert.NoError(t, mock.ExpectationsWereMet())
}

// ==================== CreateAuditLog Tests ====================

func TestCreateAuditLog_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	operation := "create"
	operatorID := "user-1"
	targetType := "incident"
	targetID := "incident-1"
	detail := "Created new incident"

	mock.ExpectExec("INSERT INTO audit_logs (.+)").
		WithArgs(operation, &operatorID, &targetType, &targetID, &detail).
		WillReturnResult(sqlmock.NewResult(1, 1))

	// Execute
	err = CreateAuditLog(db, operation, &operatorID, &targetType, &targetID, &detail)

	// Assert
	assert.NoError(t, err)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestCreateAuditLog_WithAllFields(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	operation := "update"
	operatorID := "user-1"
	targetType := "notification"
	targetID := "notif-1"
	detail := "Updated notification status"

	mock.ExpectExec("INSERT INTO audit_logs (.+)").
		WithArgs(operation, &operatorID, &targetType, &targetID, &detail).
		WillReturnResult(sqlmock.NewResult(1, 1))

	// Execute
	err = CreateAuditLog(db, operation, &operatorID, &targetType, &targetID, &detail)

	// Assert
	assert.NoError(t, err)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestCreateAuditLog_MinimalFields(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	operation := "read"

	mock.ExpectExec("INSERT INTO audit_logs (.+)").
		WithArgs(operation, nil, nil, nil, nil).
		WillReturnResult(sqlmock.NewResult(1, 1))

	// Execute
	err = CreateAuditLog(db, operation, nil, nil, nil, nil)

	// Assert
	assert.NoError(t, err)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestCreateAuditLog_DatabaseError(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	operation := "create"

	mock.ExpectExec("INSERT INTO audit_logs (.+)").
		WithArgs(operation, nil, nil, nil, nil).
		WillReturnError(sql.ErrConnDone)

	// Execute
	err = CreateAuditLog(db, operation, nil, nil, nil, nil)

	// Assert
	assert.Error(t, err)
	assert.Equal(t, sql.ErrConnDone, err)
	assert.NoError(t, mock.ExpectationsWereMet())
}

// ==================== GetConfiguration Tests ====================

func TestGetConfiguration_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	now := time.Now()
	updatedBy := "admin-1"

	rows := sqlmock.NewRows([]string{
		"id", "ai_sensitivity", "video_retention_days", "notification_rules",
		"notification_timeout_sec", "camera_on_off_config", "area_config",
		"last_updated", "updated_by",
	}).
		AddRow("config-1", 5, 30, []byte("[]"), 300, []byte("[]"), []byte("[]"), now, &updatedBy)

	mock.ExpectQuery("SELECT (.+) FROM configurations LIMIT 1").
		WillReturnRows(rows)

	// Execute
	config, err := GetConfiguration(db)

	// Assert
	assert.NoError(t, err)
	assert.NotNil(t, config)
	assert.Equal(t, "config-1", config.ID)
	assert.Equal(t, 5, config.AISensitivity)
	assert.Equal(t, 30, config.VideoRetentionDays)
	assert.Equal(t, 300, config.NotificationTimeoutSec)
	assert.NotNil(t, config.UpdatedBy)
	assert.Equal(t, updatedBy, *config.UpdatedBy)
	assert.NotNil(t, config.NotificationRules)
	assert.NotNil(t, config.CameraOnOffConfig)
	assert.NotNil(t, config.AreaConfig)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetConfiguration_NotFound(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	mock.ExpectQuery("SELECT (.+) FROM configurations LIMIT 1").
		WillReturnError(sql.ErrNoRows)

	// Execute
	config, err := GetConfiguration(db)

	// Assert
	assert.NoError(t, err)
	assert.Nil(t, config)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetConfiguration_DatabaseError(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	mock.ExpectQuery("SELECT (.+) FROM configurations LIMIT 1").
		WillReturnError(sql.ErrConnDone)

	// Execute
	config, err := GetConfiguration(db)

	// Assert
	assert.Error(t, err)
	assert.Nil(t, config)
	assert.Equal(t, sql.ErrConnDone, err)
	assert.NoError(t, mock.ExpectationsWereMet())
}

// ==================== UpdateConfiguration Tests ====================

func TestUpdateConfiguration_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	aiSensitivity := 8
	videoRetentionDays := 60
	updatedBy := "admin-1"

	input := ConfigurationUpdate{
		AISensitivity:      &aiSensitivity,
		VideoRetentionDays: &videoRetentionDays,
	}

	// Expect update
	mock.ExpectExec("UPDATE configurations SET (.+)").
		WithArgs(aiSensitivity, videoRetentionDays, updatedBy).
		WillReturnResult(sqlmock.NewResult(1, 1))

	// Expect GetConfiguration call
	now := time.Now()
	rows := sqlmock.NewRows([]string{
		"id", "ai_sensitivity", "video_retention_days", "notification_rules",
		"notification_timeout_sec", "camera_on_off_config", "area_config",
		"last_updated", "updated_by",
	}).
		AddRow("config-1", aiSensitivity, videoRetentionDays, []byte("[]"), 300, []byte("[]"), []byte("[]"), now, &updatedBy)

	mock.ExpectQuery("SELECT (.+) FROM configurations LIMIT 1").
		WillReturnRows(rows)

	// Execute
	config, err := UpdateConfiguration(db, input, updatedBy)

	// Assert
	assert.NoError(t, err)
	assert.NotNil(t, config)
	assert.Equal(t, aiSensitivity, config.AISensitivity)
	assert.Equal(t, videoRetentionDays, config.VideoRetentionDays)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestUpdateConfiguration_PartialUpdate(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	timeoutSec := 600
	updatedBy := "admin-1"

	input := ConfigurationUpdate{
		NotificationTimeoutSec: &timeoutSec,
	}

	// Expect update
	mock.ExpectExec("UPDATE configurations SET (.+)").
		WithArgs(timeoutSec, updatedBy).
		WillReturnResult(sqlmock.NewResult(1, 1))

	// Expect GetConfiguration call
	now := time.Now()
	rows := sqlmock.NewRows([]string{
		"id", "ai_sensitivity", "video_retention_days", "notification_rules",
		"notification_timeout_sec", "camera_on_off_config", "area_config",
		"last_updated", "updated_by",
	}).
		AddRow("config-1", 5, 30, []byte("[]"), timeoutSec, []byte("[]"), []byte("[]"), now, &updatedBy)

	mock.ExpectQuery("SELECT (.+) FROM configurations LIMIT 1").
		WillReturnRows(rows)

	// Execute
	config, err := UpdateConfiguration(db, input, updatedBy)

	// Assert
	assert.NoError(t, err)
	assert.NotNil(t, config)
	assert.Equal(t, timeoutSec, config.NotificationTimeoutSec)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestUpdateConfiguration_NoFieldsToUpdate(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	input := ConfigurationUpdate{}
	updatedBy := "admin-1"

	// When no fields to update, GetConfiguration is called
	now := time.Now()
	rows := sqlmock.NewRows([]string{
		"id", "ai_sensitivity", "video_retention_days", "notification_rules",
		"notification_timeout_sec", "camera_on_off_config", "area_config",
		"last_updated", "updated_by",
	}).
		AddRow("config-1", 5, 30, []byte("[]"), 300, []byte("[]"), []byte("[]"), now, &updatedBy)

	mock.ExpectQuery("SELECT (.+) FROM configurations LIMIT 1").
		WillReturnRows(rows)

	// Execute
	config, err := UpdateConfiguration(db, input, updatedBy)

	// Assert
	assert.NoError(t, err)
	assert.NotNil(t, config)
	assert.Equal(t, "config-1", config.ID)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestUpdateConfiguration_DatabaseError(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	aiSensitivity := 8
	updatedBy := "admin-1"

	input := ConfigurationUpdate{
		AISensitivity: &aiSensitivity,
	}

	mock.ExpectExec("UPDATE configurations SET (.+)").
		WithArgs(aiSensitivity, updatedBy).
		WillReturnError(sql.ErrConnDone)

	// Execute
	config, err := UpdateConfiguration(db, input, updatedBy)

	// Assert
	assert.Error(t, err)
	assert.Nil(t, config)
	assert.Equal(t, sql.ErrConnDone, err)
	assert.NoError(t, mock.ExpectationsWereMet())
}
