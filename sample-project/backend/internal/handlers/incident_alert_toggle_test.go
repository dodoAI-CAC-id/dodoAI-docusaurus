package handlers

import (
	"bytes"
	"database/sql"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"
	"time"

	"github.com/DATA-DOG/go-sqlmock"
	"github.com/stretchr/testify/assert"
)

// ==================== ToggleAlertStatus Tests (Phase 1: Red) ====================

func TestToggleAlertStatus_Deactivate_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewIncidentHandler(db)
	router.PATCH("/api/v2/incidents/:id/alert", handler.ToggleAlertStatus)

	incidentID := "incident-view-006"
	now := time.Now()
	isActive := false

	input := map[string]interface{}{
		"isActive": isActive,
	}

	// Mock the UPDATE query with JOIN to return full incident data
	updateRows := sqlmock.NewRows([]string{
		"id", "detected_at", "type", "status", "person_id", "camera_id", "room_id",
		"detection_area_id", "description", "created_by", "created_at", "updated_at",
		"person_name", "room_number", "alert_active",
	}).
		AddRow(incidentID, now, "転倒", "resolved", "person-006", "camera-006", "room-006",
			nil, nil, nil, now, now, "伊藤太郎", "203", isActive)

	mock.ExpectQuery("UPDATE incidents SET alert_active = (.+), updated_at = (.+) WHERE id = (.+) RETURNING (.+)").
		WithArgs(isActive, sqlmock.AnyArg(), incidentID).
		WillReturnRows(updateRows)

	body, _ := json.Marshal(input)
	req, _ := http.NewRequest("PATCH", "/api/v2/incidents/"+incidentID+"/alert", bytes.NewBuffer(body))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	// Debug: Print response if not 200
	if w.Code != http.StatusOK {
		t.Logf("Response body: %s", w.Body.String())
	}

	assert.Equal(t, http.StatusOK, w.Code)

	var response map[string]interface{}
	err = json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)
	assert.True(t, response["success"].(bool))

	data := response["data"].(map[string]interface{})
	assert.Equal(t, incidentID, data["id"])
	assert.Equal(t, false, data["isAlertActive"])
	assert.NotNil(t, data["roomNumber"])
	assert.NotNil(t, data["personName"])
	assert.Equal(t, "203", data["roomNumber"])
	assert.Equal(t, "伊藤太郎", data["personName"])

	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestToggleAlertStatus_Activate_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewIncidentHandler(db)
	router.PATCH("/api/v2/incidents/:id/alert", handler.ToggleAlertStatus)

	incidentID := "incident-view-006"
	now := time.Now()
	isActive := true

	input := map[string]interface{}{
		"isActive": isActive,
	}

	updateRows := sqlmock.NewRows([]string{
		"id", "detected_at", "type", "status", "person_id", "camera_id", "room_id",
		"detection_area_id", "description", "created_by", "created_at", "updated_at",
		"person_name", "room_number", "alert_active",
	}).
		AddRow(incidentID, now, "転倒", "resolved", "person-006", "camera-006", "room-006",
			nil, nil, nil, now, now, "伊藤太郎", "203", isActive)

	mock.ExpectQuery("UPDATE incidents SET alert_active = (.+), updated_at = (.+) WHERE id = (.+) RETURNING (.+)").
		WithArgs(isActive, sqlmock.AnyArg(), incidentID).
		WillReturnRows(updateRows)

	body, _ := json.Marshal(input)
	req, _ := http.NewRequest("PATCH", "/api/v2/incidents/"+incidentID+"/alert", bytes.NewBuffer(body))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)

	var response map[string]interface{}
	err = json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)
	assert.True(t, response["success"].(bool))

	data := response["data"].(map[string]interface{})
	assert.Equal(t, incidentID, data["id"])
	assert.Equal(t, true, data["isAlertActive"])

	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestToggleAlertStatus_NotFound(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewIncidentHandler(db)
	router.PATCH("/api/v2/incidents/:id/alert", handler.ToggleAlertStatus)

	incidentID := "non-existent-id"
	isActive := false

	input := map[string]interface{}{
		"isActive": isActive,
	}

	mock.ExpectQuery("UPDATE incidents SET alert_active = (.+), updated_at = (.+) WHERE id = (.+) RETURNING (.+)").
		WithArgs(isActive, sqlmock.AnyArg(), incidentID).
		WillReturnError(sql.ErrNoRows)

	body, _ := json.Marshal(input)
	req, _ := http.NewRequest("PATCH", "/api/v2/incidents/"+incidentID+"/alert", bytes.NewBuffer(body))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusNotFound, w.Code)

	var response map[string]interface{}
	err = json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)
	assert.False(t, response["success"].(bool))
	assert.Contains(t, response["message"].(string), "Incident not found")

	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestToggleAlertStatus_InvalidJSON(t *testing.T) {
	db, _, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewIncidentHandler(db)
	router.PATCH("/api/v2/incidents/:id/alert", handler.ToggleAlertStatus)

	incidentID := "incident-view-006"

	req, _ := http.NewRequest("PATCH", "/api/v2/incidents/"+incidentID+"/alert", bytes.NewBuffer([]byte("invalid json")))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusBadRequest, w.Code)

	var response map[string]interface{}
	err = json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)
	assert.False(t, response["success"].(bool))
}

func TestToggleAlertStatus_MissingIsActive(t *testing.T) {
	db, _, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewIncidentHandler(db)
	router.PATCH("/api/v2/incidents/:id/alert", handler.ToggleAlertStatus)

	incidentID := "incident-view-006"

	input := map[string]interface{}{} // Missing isActive field

	body, _ := json.Marshal(input)
	req, _ := http.NewRequest("PATCH", "/api/v2/incidents/"+incidentID+"/alert", bytes.NewBuffer(body))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusBadRequest, w.Code)

	var response map[string]interface{}
	err = json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)
	assert.False(t, response["success"].(bool))
	assert.Contains(t, response["message"].(string), "isActive")
}

func TestToggleAlertStatus_DatabaseError(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewIncidentHandler(db)
	router.PATCH("/api/v2/incidents/:id/alert", handler.ToggleAlertStatus)

	incidentID := "incident-view-006"
	isActive := false

	input := map[string]interface{}{
		"isActive": isActive,
	}

	mock.ExpectQuery("UPDATE incidents SET alert_active = (.+), updated_at = (.+) WHERE id = (.+) RETURNING (.+)").
		WithArgs(isActive, sqlmock.AnyArg(), incidentID).
		WillReturnError(sql.ErrConnDone)

	body, _ := json.Marshal(input)
	req, _ := http.NewRequest("PATCH", "/api/v2/incidents/"+incidentID+"/alert", bytes.NewBuffer(body))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusInternalServerError, w.Code)

	assert.NoError(t, mock.ExpectationsWereMet())
}
