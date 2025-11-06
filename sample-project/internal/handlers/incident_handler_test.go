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
	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
)

func setupTestRouter() *gin.Engine {
	gin.SetMode(gin.TestMode)
	return gin.Default()
}

// ==================== GetIncidents Tests ====================

func TestGetIncidents_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewIncidentHandler(db)
	router.GET("/api/v2/incidents", handler.GetIncidents)

	now := time.Now()
	rows := sqlmock.NewRows([]string{
		"id", "detected_at", "type", "status", "person_id", "camera_id", "room_id",
		"detection_area_id", "description", "created_by", "created_at", "updated_at",
	}).
		AddRow("incident-1", now, "fall", "open", "person-1", "camera-1", nil,
			nil, nil, nil, now, now)

	mock.ExpectQuery("SELECT (.+) FROM incidents WHERE 1=1 ORDER BY detected_at DESC").
		WillReturnRows(rows)

	req, _ := http.NewRequest("GET", "/api/v2/incidents", nil)
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

func TestGetIncidents_WithFilters(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewIncidentHandler(db)
	router.GET("/api/v2/incidents", handler.GetIncidents)

	personID := "person-1"
	status := "pending"
	now := time.Now()

	rows := sqlmock.NewRows([]string{
		"id", "detected_at", "type", "status", "person_id", "camera_id", "room_id",
		"detection_area_id", "description", "created_by", "created_at", "updated_at",
	}).
		AddRow("incident-1", now, "fall", status, personID, "camera-1", nil,
			nil, nil, nil, now, now)

	mock.ExpectQuery("SELECT (.+) FROM incidents WHERE 1=1 AND person_id = (.+) AND status = (.+) ORDER BY detected_at DESC").
		WithArgs(personID, status).
		WillReturnRows(rows)

	req, _ := http.NewRequest("GET", "/api/v2/incidents?personId=person-1&status=pending", nil)
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetIncidents_InvalidTimeFormat(t *testing.T) {
	db, _, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewIncidentHandler(db)
	router.GET("/api/v2/incidents", handler.GetIncidents)

	req, _ := http.NewRequest("GET", "/api/v2/incidents?from=invalid-time", nil)
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusBadRequest, w.Code)

	var response map[string]interface{}
	err = json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)
	assert.False(t, response["success"].(bool))
	assert.Contains(t, response["message"].(string), "Invalid 'from' timestamp format")
}

func TestGetIncidents_DatabaseError(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewIncidentHandler(db)
	router.GET("/api/v2/incidents", handler.GetIncidents)

	mock.ExpectQuery("SELECT (.+) FROM incidents WHERE 1=1 ORDER BY detected_at DESC").
		WillReturnError(sql.ErrConnDone)

	req, _ := http.NewRequest("GET", "/api/v2/incidents", nil)
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusInternalServerError, w.Code)
	assert.NoError(t, mock.ExpectationsWereMet())
}

// ==================== CreateIncident Tests ====================

func TestCreateIncident_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewIncidentHandler(db)
	router.POST("/api/v2/incidents", handler.CreateIncident)

	now := time.Now().Truncate(time.Second)
	description := "Test fall incident"
	input := models.IncidentCreate{
		DetectedAt:  now,
		Type:        "fall",
		PersonID:    "person-1",
		CameraID:    "camera-1",
		Description: &description,
	}

	// Mock staff query for auto-notification
	staffRows := sqlmock.NewRows([]string{"id"}).
		AddRow("staff-1").
		AddRow("staff-2")
	mock.ExpectBegin()
	mock.ExpectQuery("INSERT INTO incidents (.+) RETURNING (.+)").
		WithArgs(sqlmock.AnyArg(), input.Type, input.PersonID, input.CameraID, input.RoomID, input.DetectionAreaID, input.Description).
		WillReturnRows(sqlmock.NewRows([]string{
			"id", "detected_at", "type", "status", "person_id", "camera_id", "room_id",
			"detection_area_id", "description", "created_by", "created_at", "updated_at",
		}).AddRow("new-incident", now, input.Type, "open", input.PersonID, input.CameraID, nil,
			nil, input.Description, nil, now, now))

	mock.ExpectQuery("SELECT id FROM staffs WHERE role IN").
		WillReturnRows(staffRows)
	mock.ExpectExec("INSERT INTO notifications").
		WillReturnResult(sqlmock.NewResult(1, 1))
	mock.ExpectExec("INSERT INTO notification_histories").
		WillReturnResult(sqlmock.NewResult(1, 1))
	mock.ExpectExec("INSERT INTO notification_histories").
		WillReturnResult(sqlmock.NewResult(1, 1))
	mock.ExpectCommit()

	body, _ := json.Marshal(input)
	req, _ := http.NewRequest("POST", "/api/v2/incidents", bytes.NewBuffer(body))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	// Debug: Print response body if not 201
	if w.Code != http.StatusCreated {
		t.Logf("Response body: %s", w.Body.String())
	}

	assert.Equal(t, http.StatusCreated, w.Code)

	var response map[string]interface{}
	err = json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)
	assert.True(t, response["success"].(bool))

	data := response["data"].(map[string]interface{})
	assert.Equal(t, "new-incident", data["id"])
	assert.Equal(t, "open", data["status"])
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestCreateIncident_MissingRequiredFields(t *testing.T) {
	db, _, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewIncidentHandler(db)
	router.POST("/api/v2/incidents", handler.CreateIncident)

	tests := []struct {
		name     string
		input    map[string]interface{}
		errorMsg string
	}{
		{
			name:     "Missing detectedAt",
			input:    map[string]interface{}{"type": "fall", "personId": "p1", "cameraId": "c1"},
			errorMsg: "detectedAt is required",
		},
		{
			name:     "Missing type",
			input:    map[string]interface{}{"detectedAt": time.Now().Format(time.RFC3339), "personId": "p1", "cameraId": "c1"},
			errorMsg: "type is required",
		},
		{
			name:     "Missing personId",
			input:    map[string]interface{}{"detectedAt": time.Now().Format(time.RFC3339), "type": "fall", "cameraId": "c1"},
			errorMsg: "personId is required",
		},
		{
			name:     "Missing cameraId",
			input:    map[string]interface{}{"detectedAt": time.Now().Format(time.RFC3339), "type": "fall", "personId": "p1"},
			errorMsg: "cameraId is required",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			body, _ := json.Marshal(tt.input)
			req, _ := http.NewRequest("POST", "/api/v2/incidents", bytes.NewBuffer(body))
			req.Header.Set("Content-Type", "application/json")
			w := httptest.NewRecorder()
			router.ServeHTTP(w, req)

			assert.Equal(t, http.StatusBadRequest, w.Code)

			var response map[string]interface{}
			err = json.Unmarshal(w.Body.Bytes(), &response)
			assert.NoError(t, err)
			assert.False(t, response["success"].(bool))
			assert.Contains(t, response["message"].(string), tt.errorMsg)
		})
	}
}

func TestCreateIncident_InvalidJSON(t *testing.T) {
	db, _, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewIncidentHandler(db)
	router.POST("/api/v2/incidents", handler.CreateIncident)

	req, _ := http.NewRequest("POST", "/api/v2/incidents", bytes.NewBuffer([]byte("invalid json")))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusBadRequest, w.Code)
}

func TestCreateIncident_DatabaseError(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewIncidentHandler(db)
	router.POST("/api/v2/incidents", handler.CreateIncident)

	now := time.Now()
	input := models.IncidentCreate{
		DetectedAt: now,
		Type:       "fall",
		PersonID:   "person-1",
		CameraID:   "camera-1",
	}

	mock.ExpectBegin()
	mock.ExpectQuery("INSERT INTO incidents (.+) RETURNING (.+)").
		WillReturnError(sql.ErrConnDone)
	mock.ExpectRollback()

	body, _ := json.Marshal(input)
	req, _ := http.NewRequest("POST", "/api/v2/incidents", bytes.NewBuffer(body))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusInternalServerError, w.Code)
	assert.NoError(t, mock.ExpectationsWereMet())
}

// ==================== GetIncident Tests ====================

func TestGetIncident_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewIncidentHandler(db)
	router.GET("/api/v2/incidents/:id", handler.GetIncident)

	incidentID := "incident-1"
	now := time.Now()

	rows := sqlmock.NewRows([]string{
		"id", "detected_at", "type", "status", "person_id", "camera_id", "room_id",
		"detection_area_id", "description", "created_by", "created_at", "updated_at",
	}).
		AddRow(incidentID, now, "fall", "open", "person-1", "camera-1", nil,
			nil, nil, nil, now, now)

	mock.ExpectQuery("SELECT (.+) FROM incidents WHERE id = (.+)").
		WithArgs(incidentID).
		WillReturnRows(rows)
	mock.ExpectQuery("SELECT (.+) FROM notifications WHERE incident_id = (.+)").
		WithArgs(incidentID).
		WillReturnRows(sqlmock.NewRows([]string{"id", "incident_id", "sent_to_staff_ids", "notification_type", "action_required", "unread_by_staff_ids", "escalation_level", "sent_at"}))
	mock.ExpectQuery("SELECT (.+) FROM actions WHERE incident_id = (.+)").
		WithArgs(incidentID).
		WillReturnRows(sqlmock.NewRows([]string{"id", "incident_id", "type", "staff_id", "note", "progress", "action_time", "created_at"}))
	mock.ExpectQuery("SELECT (.+) FROM incident_videos WHERE incident_id = (.+)").
		WithArgs(incidentID).
		WillReturnRows(sqlmock.NewRows([]string{"id", "incident_id", "file_url", "thumbnail_url", "mosaic", "span_start", "span_end", "created_at"}))

	req, _ := http.NewRequest("GET", "/api/v2/incidents/"+incidentID, nil)
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)

	var response map[string]interface{}
	err = json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)
	assert.True(t, response["success"].(bool))
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetIncident_NotFound(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewIncidentHandler(db)
	router.GET("/api/v2/incidents/:id", handler.GetIncident)

	incidentID := "non-existent"

	mock.ExpectQuery("SELECT (.+) FROM incidents WHERE id = (.+)").
		WithArgs(incidentID).
		WillReturnError(sql.ErrNoRows)

	req, _ := http.NewRequest("GET", "/api/v2/incidents/"+incidentID, nil)
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

func TestGetIncident_DatabaseError(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewIncidentHandler(db)
	router.GET("/api/v2/incidents/:id", handler.GetIncident)

	incidentID := "incident-1"

	mock.ExpectQuery("SELECT (.+) FROM incidents WHERE id = (.+)").
		WithArgs(incidentID).
		WillReturnError(sql.ErrConnDone)

	req, _ := http.NewRequest("GET", "/api/v2/incidents/"+incidentID, nil)
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusInternalServerError, w.Code)
	assert.NoError(t, mock.ExpectationsWereMet())
}

// ==================== UpdateIncident Tests ====================

func TestUpdateIncident_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewIncidentHandler(db)
	router.PATCH("/api/v2/incidents/:id", handler.UpdateIncident)

	incidentID := "incident-1"
	status := "resolved"
	now := time.Now()

	input := models.IncidentUpdate{
		Status: &status,
	}

	updateRows := sqlmock.NewRows([]string{
		"id", "detected_at", "type", "status", "person_id", "camera_id", "room_id",
		"detection_area_id", "description", "created_by", "created_at", "updated_at",
	}).
		AddRow(incidentID, now, "fall", status, "person-1", "camera-1", nil,
			nil, nil, nil, now, now)

	mock.ExpectQuery("UPDATE incidents SET (.+) WHERE id = (.+) RETURNING (.+)").
		WithArgs(status, incidentID).
		WillReturnRows(updateRows)

	body, _ := json.Marshal(input)
	req, _ := http.NewRequest("PATCH", "/api/v2/incidents/"+incidentID, bytes.NewBuffer(body))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)

	var response map[string]interface{}
	err = json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)
	assert.True(t, response["success"].(bool))
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestUpdateIncident_NotFound(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewIncidentHandler(db)
	router.PATCH("/api/v2/incidents/:id", handler.UpdateIncident)

	incidentID := "non-existent"
	status := "resolved"

	input := models.IncidentUpdate{
		Status: &status,
	}

	mock.ExpectQuery("UPDATE incidents SET (.+) WHERE id = (.+) RETURNING (.+)").
		WithArgs(status, incidentID).
		WillReturnError(sql.ErrNoRows)

	body, _ := json.Marshal(input)
	req, _ := http.NewRequest("PATCH", "/api/v2/incidents/"+incidentID, bytes.NewBuffer(body))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusNotFound, w.Code)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestUpdateIncident_InvalidJSON(t *testing.T) {
	db, _, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewIncidentHandler(db)
	router.PATCH("/api/v2/incidents/:id", handler.UpdateIncident)

	incidentID := "incident-1"

	req, _ := http.NewRequest("PATCH", "/api/v2/incidents/"+incidentID, bytes.NewBuffer([]byte("invalid json")))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusBadRequest, w.Code)
}

// Helper function
func stringPtr(s string) *string {
	return &s
}
