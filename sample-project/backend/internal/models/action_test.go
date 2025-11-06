package models

import (
	"database/sql"
	"testing"
	"time"

	"github.com/DATA-DOG/go-sqlmock"
	"github.com/stretchr/testify/assert"
)

// ==================== GetActionsByIncidentID Tests ====================

func TestGetActionsByIncidentID_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	incidentID := "test-incident-id"
	now := time.Now()
	endAt := now.Add(1 * time.Hour)
	note := "Test action note"

	rows := sqlmock.NewRows([]string{
		"id", "incident_id", "staff_id", "action_type", "progress",
		"start_at", "end_at", "note", "created_at",
	}).
		AddRow("action-1", incidentID, "staff-1", "start", "in_progress",
			now, nil, nil, now).
		AddRow("action-2", incidentID, "staff-2", "complete", "completed",
			now, &endAt, &note, now)

	mock.ExpectQuery("SELECT (.+) FROM actions WHERE incident_id = (.+) ORDER BY created_at DESC").
		WithArgs(incidentID).
		WillReturnRows(rows)

	// Execute
	actions, err := GetActionsByIncidentID(db, incidentID)

	// Assert
	assert.NoError(t, err)
	assert.Len(t, actions, 2)
	assert.Equal(t, "action-1", actions[0].ID)
	assert.Equal(t, "start", actions[0].ActionType)
	assert.Equal(t, "in_progress", actions[0].Progress)
	assert.Nil(t, actions[0].EndAt)
	assert.Equal(t, "action-2", actions[1].ID)
	assert.Equal(t, "complete", actions[1].ActionType)
	assert.Equal(t, "completed", actions[1].Progress)
	assert.NotNil(t, actions[1].EndAt)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetActionsByIncidentID_EmptyResult(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	incidentID := "incident-no-actions"

	rows := sqlmock.NewRows([]string{
		"id", "incident_id", "staff_id", "action_type", "progress",
		"start_at", "end_at", "note", "created_at",
	})

	mock.ExpectQuery("SELECT (.+) FROM actions WHERE incident_id = (.+) ORDER BY created_at DESC").
		WithArgs(incidentID).
		WillReturnRows(rows)

	// Execute
	actions, err := GetActionsByIncidentID(db, incidentID)

	// Assert
	assert.NoError(t, err)
	assert.Empty(t, actions)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetActionsByIncidentID_MultipleActions(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	incidentID := "incident-many-actions"
	now := time.Now()

	rows := sqlmock.NewRows([]string{
		"id", "incident_id", "staff_id", "action_type", "progress",
		"start_at", "end_at", "note", "created_at",
	})

	// Add 5 actions
	for i := 1; i <= 5; i++ {
		rows.AddRow(
			"action-"+string(rune('0'+i)),
			incidentID,
			"staff-1",
			"start",
			"in_progress",
			now,
			nil,
			nil,
			now,
		)
	}

	mock.ExpectQuery("SELECT (.+) FROM actions WHERE incident_id = (.+) ORDER BY created_at DESC").
		WithArgs(incidentID).
		WillReturnRows(rows)

	// Execute
	actions, err := GetActionsByIncidentID(db, incidentID)

	// Assert
	assert.NoError(t, err)
	assert.Len(t, actions, 5)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetActionsByIncidentID_DatabaseError(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	incidentID := "test-incident-id"

	mock.ExpectQuery("SELECT (.+) FROM actions WHERE incident_id = (.+) ORDER BY created_at DESC").
		WithArgs(incidentID).
		WillReturnError(sql.ErrConnDone)

	// Execute
	actions, err := GetActionsByIncidentID(db, incidentID)

	// Assert
	assert.Error(t, err)
	assert.Nil(t, actions)
	assert.Equal(t, sql.ErrConnDone, err)
	assert.NoError(t, mock.ExpectationsWereMet())
}

// ==================== GetActionsWithDetailsByIncidentID Tests ====================

func TestGetActionsWithDetailsByIncidentID_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	incidentID := "test-incident-id"
	now := time.Now()

	rows := sqlmock.NewRows([]string{
		"id", "incident_id", "staff_id", "action_type", "progress",
		"start_at", "end_at", "note", "created_at",
		"room_bed", "person_name", "incident_type",
	}).
		AddRow("action-1", incidentID, "staff-1", "start", "in_progress",
			now, nil, nil, now, "101", "山田太郎", "fall")

	mock.ExpectQuery("SELECT (.+) FROM actions a JOIN incidents i (.+) WHERE a.incident_id = (.+) ORDER BY a.created_at DESC").
		WithArgs(incidentID).
		WillReturnRows(rows)

	// Execute
	actions, err := GetActionsWithDetailsByIncidentID(db, incidentID)

	// Assert
	assert.NoError(t, err)
	assert.Len(t, actions, 1)
	assert.Equal(t, "action-1", actions[0].ID)
	assert.Equal(t, "101", actions[0].RoomBedNameOrNumber)
	assert.Equal(t, "山田太郎", actions[0].PersonName)
	assert.Equal(t, "fall", actions[0].IncidentDetectionType)
	assert.NoError(t, mock.ExpectationsWereMet())
}

// ==================== CreateAction Tests ====================

func TestCreateAction_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	incidentID := "test-incident-id"
	input := ActionCreate{
		StaffID:    "staff-1",
		ActionType: "start",
		Note:       nil,
	}

	now := time.Now()

	// Expect action insert
	actionRows := sqlmock.NewRows([]string{
		"id", "incident_id", "staff_id", "action_type", "progress",
		"start_at", "end_at", "note", "created_at",
	}).
		AddRow("new-action-id", incidentID, input.StaffID, input.ActionType,
			"in_progress", now, nil, input.Note, now)

	mock.ExpectQuery("INSERT INTO actions (.+) RETURNING (.+)").
		WithArgs(incidentID, input.StaffID, input.ActionType, "in_progress", input.Note).
		WillReturnRows(actionRows)

	// Execute
	action, err := CreateAction(db, incidentID, input)

	// Assert
	assert.NoError(t, err)
	assert.NotNil(t, action)
	assert.Equal(t, "new-action-id", action.ID)
	assert.Equal(t, incidentID, action.IncidentID)
	assert.Equal(t, "staff-1", action.StaffID)
	assert.Equal(t, "start", action.ActionType)
	assert.Equal(t, "in_progress", action.Progress)
	assert.Nil(t, action.EndAt)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestCreateAction_WithNote(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	incidentID := "test-incident-id"
	note := "Started investigating the incident"
	input := ActionCreate{
		StaffID:    "staff-1",
		ActionType: "start",
		Note:       &note,
	}

	now := time.Now()

	// Expect action insert with note
	actionRows := sqlmock.NewRows([]string{
		"id", "incident_id", "staff_id", "action_type", "progress",
		"start_at", "end_at", "note", "created_at",
	}).
		AddRow("new-action-id", incidentID, input.StaffID, input.ActionType,
			"in_progress", now, nil, input.Note, now)

	mock.ExpectQuery("INSERT INTO actions (.+) RETURNING (.+)").
		WithArgs(incidentID, input.StaffID, input.ActionType, "in_progress", input.Note).
		WillReturnRows(actionRows)

	// Execute
	action, err := CreateAction(db, incidentID, input)

	// Assert
	assert.NoError(t, err)
	assert.NotNil(t, action)
	assert.NotNil(t, action.Note)
	assert.Equal(t, note, *action.Note)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestCreateAction_CompleteType(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	incidentID := "test-incident-id"
	input := ActionCreate{
		StaffID:    "staff-1",
		ActionType: "complete",
		Note:       nil,
	}

	now := time.Now()
	endAt := now.Add(1 * time.Hour)

	// Expect action insert with complete type
	actionRows := sqlmock.NewRows([]string{
		"id", "incident_id", "staff_id", "action_type", "progress",
		"start_at", "end_at", "note", "created_at",
	}).
		AddRow("new-action-id", incidentID, input.StaffID, input.ActionType,
			"completed", now, &endAt, input.Note, now)

	mock.ExpectQuery("INSERT INTO actions (.+) RETURNING (.+)").
		WithArgs(incidentID, input.StaffID, input.ActionType, "completed", input.Note).
		WillReturnRows(actionRows)

	// Expect update action end_at
	mock.ExpectExec("UPDATE actions SET end_at = CURRENT_TIMESTAMP, progress = 'completed' WHERE id = (.+)").
		WithArgs("new-action-id").
		WillReturnResult(sqlmock.NewResult(1, 1))

	// Expect update incident status
	mock.ExpectExec("UPDATE incidents SET status = 'resolved' WHERE id = (.+) AND status != 'resolved'").
		WithArgs(incidentID).
		WillReturnResult(sqlmock.NewResult(1, 1))

	// Execute
	action, err := CreateAction(db, incidentID, input)

	// Assert
	assert.NoError(t, err)
	assert.NotNil(t, action)
	assert.Equal(t, "complete", action.ActionType)
	assert.Equal(t, "completed", action.Progress)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestCreateAction_DatabaseError(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	incidentID := "test-incident-id"
	input := ActionCreate{
		StaffID:    "staff-1",
		ActionType: "start",
		Note:       nil,
	}

	mock.ExpectQuery("INSERT INTO actions (.+) RETURNING (.+)").
		WithArgs(incidentID, input.StaffID, input.ActionType, "in_progress", input.Note).
		WillReturnError(sql.ErrConnDone)

	// Execute
	action, err := CreateAction(db, incidentID, input)

	// Assert
	assert.Error(t, err)
	assert.Nil(t, action)
	assert.Equal(t, sql.ErrConnDone, err)
	assert.NoError(t, mock.ExpectationsWereMet())
}

// ==================== UpdateActionProgress Tests ====================

func TestUpdateActionProgress_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	actionID := "test-action-id"
	progress := "monitoring"

	mock.ExpectExec("UPDATE actions SET progress = (.+) WHERE id = (.+)").
		WithArgs(progress, actionID).
		WillReturnResult(sqlmock.NewResult(1, 1))

	// Execute
	err = UpdateActionProgress(db, actionID, progress)

	// Assert
	assert.NoError(t, err)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestUpdateActionProgress_ToCompleted(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	actionID := "test-action-id"
	progress := "completed"

	// When progress is completed, end_at should be set
	mock.ExpectExec("UPDATE actions SET progress = (.+), end_at = CURRENT_TIMESTAMP WHERE id = (.+)").
		WithArgs(progress, actionID).
		WillReturnResult(sqlmock.NewResult(1, 1))

	// Execute
	err = UpdateActionProgress(db, actionID, progress)

	// Assert
	assert.NoError(t, err)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestUpdateActionProgress_NotFound(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	actionID := "non-existent-id"
	progress := "monitoring"

	mock.ExpectExec("UPDATE actions SET progress = (.+) WHERE id = (.+)").
		WithArgs(progress, actionID).
		WillReturnResult(sqlmock.NewResult(0, 0))

	// Execute
	err = UpdateActionProgress(db, actionID, progress)

	// Assert
	// Note: The current implementation doesn't return an error for 0 rows affected
	assert.NoError(t, err)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestUpdateActionProgress_DatabaseError(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	actionID := "test-action-id"
	progress := "monitoring"

	mock.ExpectExec("UPDATE actions SET progress = (.+) WHERE id = (.+)").
		WithArgs(progress, actionID).
		WillReturnError(sql.ErrConnDone)

	// Execute
	err = UpdateActionProgress(db, actionID, progress)

	// Assert
	assert.Error(t, err)
	assert.Equal(t, sql.ErrConnDone, err)
	assert.NoError(t, mock.ExpectationsWereMet())
}
