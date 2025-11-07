package handlers

import (
	"bytes"
	"database/sql"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"sample-project/internal/models"
	"testing"
	"time"

	"github.com/DATA-DOG/go-sqlmock"
	"github.com/stretchr/testify/assert"
)

// ==================== GetActionsByIncident Tests ====================

func TestGetActionsByIncident_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewActionHandler(db)
	router.GET("/api/v2/incidents/:id/actions", handler.GetActionsByIncident)

	incidentID := "incident-1"
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

	req, _ := http.NewRequest("GET", "/api/v2/incidents/"+incidentID+"/actions", nil)
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)

	var response map[string]interface{}
	err = json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)
	assert.True(t, response["success"].(bool))

	data := response["data"].([]interface{})
	assert.Len(t, data, 1)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetActionsByIncident_EmptyResult(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewActionHandler(db)
	router.GET("/api/v2/incidents/:id/actions", handler.GetActionsByIncident)

	incidentID := "incident-no-actions"

	rows := sqlmock.NewRows([]string{
		"id", "incident_id", "staff_id", "action_type", "progress",
		"start_at", "end_at", "note", "created_at",
		"room_bed", "person_name", "incident_type",
	})

	mock.ExpectQuery("SELECT (.+) FROM actions a JOIN incidents i (.+) WHERE a.incident_id = (.+) ORDER BY a.created_at DESC").
		WithArgs(incidentID).
		WillReturnRows(rows)

	req, _ := http.NewRequest("GET", "/api/v2/incidents/"+incidentID+"/actions", nil)
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)

	var response map[string]interface{}
	err = json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)
	assert.True(t, response["success"].(bool))

	data := response["data"].([]interface{})
	assert.Empty(t, data)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetActionsByIncident_MultipleActions(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewActionHandler(db)
	router.GET("/api/v2/incidents/:id/actions", handler.GetActionsByIncident)

	incidentID := "incident-many-actions"
	now := time.Now()

	rows := sqlmock.NewRows([]string{
		"id", "incident_id", "staff_id", "action_type", "progress",
		"start_at", "end_at", "note", "created_at",
		"room_bed", "person_name", "incident_type",
	}).
		AddRow("action-1", incidentID, "staff-1", "start", "in_progress",
			now, nil, nil, now, "101", "山田太郎", "fall").
		AddRow("action-2", incidentID, "staff-2", "complete", "completed",
			now, &now, nil, now, "101", "山田太郎", "fall")

	mock.ExpectQuery("SELECT (.+) FROM actions a JOIN incidents i (.+) WHERE a.incident_id = (.+) ORDER BY a.created_at DESC").
		WithArgs(incidentID).
		WillReturnRows(rows)

	req, _ := http.NewRequest("GET", "/api/v2/incidents/"+incidentID+"/actions", nil)
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)

	var response map[string]interface{}
	err = json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)
	assert.True(t, response["success"].(bool))

	data := response["data"].([]interface{})
	assert.Len(t, data, 2)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetActionsByIncident_DatabaseError(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewActionHandler(db)
	router.GET("/api/v2/incidents/:id/actions", handler.GetActionsByIncident)

	incidentID := "incident-1"

	mock.ExpectQuery("SELECT (.+) FROM actions a JOIN incidents i (.+) WHERE a.incident_id = (.+) ORDER BY a.created_at DESC").
		WithArgs(incidentID).
		WillReturnError(sql.ErrConnDone)

	req, _ := http.NewRequest("GET", "/api/v2/incidents/"+incidentID+"/actions", nil)
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusInternalServerError, w.Code)
	assert.NoError(t, mock.ExpectationsWereMet())
}

// ==================== CreateAction Tests ====================

func TestCreateAction_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewActionHandler(db)
	router.POST("/api/v2/incidents/:id/actions", handler.CreateAction)

	incidentID := "incident-1"
	input := models.ActionCreate{
		StaffID:    "staff-1",
		ActionType: "start",
		Note:       nil,
	}

	now := time.Now()

	actionRows := sqlmock.NewRows([]string{
		"id", "incident_id", "staff_id", "action_type", "progress",
		"start_at", "end_at", "note", "created_at",
	}).
		AddRow("new-action-id", incidentID, input.StaffID, input.ActionType,
			"in_progress", now, nil, input.Note, now)

	mock.ExpectQuery("INSERT INTO actions (.+) RETURNING (.+)").
		WithArgs(incidentID, input.StaffID, input.ActionType, "in_progress", input.Note).
		WillReturnRows(actionRows)

	body, _ := json.Marshal(input)
	req, _ := http.NewRequest("POST", "/api/v2/incidents/"+incidentID+"/actions", bytes.NewBuffer(body))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusCreated, w.Code)

	var response map[string]interface{}
	err = json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)
	assert.True(t, response["success"].(bool))

	data := response["data"].(map[string]interface{})
	assert.Equal(t, "new-action-id", data["id"])
	assert.Equal(t, "in_progress", data["progress"])
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestCreateAction_WithNote(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewActionHandler(db)
	router.POST("/api/v2/incidents/:id/actions", handler.CreateAction)

	incidentID := "incident-1"
	note := "Started investigating the incident"
	input := models.ActionCreate{
		StaffID:    "staff-1",
		ActionType: "start",
		Note:       &note,
	}

	now := time.Now()

	actionRows := sqlmock.NewRows([]string{
		"id", "incident_id", "staff_id", "action_type", "progress",
		"start_at", "end_at", "note", "created_at",
	}).
		AddRow("new-action-id", incidentID, input.StaffID, input.ActionType,
			"in_progress", now, nil, input.Note, now)

	mock.ExpectQuery("INSERT INTO actions (.+) RETURNING (.+)").
		WithArgs(incidentID, input.StaffID, input.ActionType, "in_progress", input.Note).
		WillReturnRows(actionRows)

	body, _ := json.Marshal(input)
	req, _ := http.NewRequest("POST", "/api/v2/incidents/"+incidentID+"/actions", bytes.NewBuffer(body))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusCreated, w.Code)

	var response map[string]interface{}
	err = json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)
	assert.True(t, response["success"].(bool))

	data := response["data"].(map[string]interface{})
	assert.Equal(t, "new-action-id", data["id"])
	assert.NotNil(t, data["note"])
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestCreateAction_CompleteType(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewActionHandler(db)
	router.POST("/api/v2/incidents/:id/actions", handler.CreateAction)

	incidentID := "incident-1"
	input := models.ActionCreate{
		StaffID:    "staff-1",
		ActionType: "complete",
		Note:       nil,
	}

	now := time.Now()

	actionRows := sqlmock.NewRows([]string{
		"id", "incident_id", "staff_id", "action_type", "progress",
		"start_at", "end_at", "note", "created_at",
	}).
		AddRow("new-action-id", incidentID, input.StaffID, input.ActionType,
			"completed", now, &now, input.Note, now)

	mock.ExpectQuery("INSERT INTO actions (.+) RETURNING (.+)").
		WithArgs(incidentID, input.StaffID, input.ActionType, "completed", input.Note).
		WillReturnRows(actionRows)

	mock.ExpectExec("UPDATE actions SET end_at = CURRENT_TIMESTAMP, progress = 'completed' WHERE id = (.+)").
		WithArgs("new-action-id").
		WillReturnResult(sqlmock.NewResult(1, 1))

	mock.ExpectExec("UPDATE incidents SET status = 'resolved' WHERE id = (.+) AND status != 'resolved'").
		WithArgs(incidentID).
		WillReturnResult(sqlmock.NewResult(1, 1))

	body, _ := json.Marshal(input)
	req, _ := http.NewRequest("POST", "/api/v2/incidents/"+incidentID+"/actions", bytes.NewBuffer(body))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusCreated, w.Code)

	var response map[string]interface{}
	err = json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)
	assert.True(t, response["success"].(bool))

	data := response["data"].(map[string]interface{})
	assert.Equal(t, "complete", data["actionType"])
	assert.Equal(t, "completed", data["progress"])
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestCreateAction_MissingStaffID(t *testing.T) {
	db, _, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewActionHandler(db)
	router.POST("/api/v2/incidents/:id/actions", handler.CreateAction)

	incidentID := "incident-1"
	input := models.ActionCreate{
		ActionType: "start",
	}

	body, _ := json.Marshal(input)
	req, _ := http.NewRequest("POST", "/api/v2/incidents/"+incidentID+"/actions", bytes.NewBuffer(body))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusBadRequest, w.Code)

	var response map[string]interface{}
	err = json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)
	assert.False(t, response["success"].(bool))
	assert.Contains(t, response["message"].(string), "staffId is required")
}

func TestCreateAction_MissingActionType(t *testing.T) {
	db, _, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewActionHandler(db)
	router.POST("/api/v2/incidents/:id/actions", handler.CreateAction)

	incidentID := "incident-1"
	input := models.ActionCreate{
		StaffID: "staff-1",
	}

	body, _ := json.Marshal(input)
	req, _ := http.NewRequest("POST", "/api/v2/incidents/"+incidentID+"/actions", bytes.NewBuffer(body))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusBadRequest, w.Code)

	var response map[string]interface{}
	err = json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)
	assert.False(t, response["success"].(bool))
	assert.Contains(t, response["message"].(string), "actionType is required")
}

func TestCreateAction_InvalidJSON(t *testing.T) {
	db, _, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewActionHandler(db)
	router.POST("/api/v2/incidents/:id/actions", handler.CreateAction)

	incidentID := "incident-1"

	req, _ := http.NewRequest("POST", "/api/v2/incidents/"+incidentID+"/actions", bytes.NewBuffer([]byte("invalid json")))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusBadRequest, w.Code)
}

func TestCreateAction_DatabaseError(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewActionHandler(db)
	router.POST("/api/v2/incidents/:id/actions", handler.CreateAction)

	incidentID := "incident-1"
	input := models.ActionCreate{
		StaffID:    "staff-1",
		ActionType: "start",
	}

	mock.ExpectQuery("INSERT INTO actions (.+) RETURNING (.+)").
		WithArgs(incidentID, input.StaffID, input.ActionType, "in_progress", input.Note).
		WillReturnError(sql.ErrConnDone)

	body, _ := json.Marshal(input)
	req, _ := http.NewRequest("POST", "/api/v2/incidents/"+incidentID+"/actions", bytes.NewBuffer(body))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusInternalServerError, w.Code)
	assert.NoError(t, mock.ExpectationsWereMet())
}
