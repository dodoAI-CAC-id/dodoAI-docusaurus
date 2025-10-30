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
	"github.com/lib/pq"
	"github.com/stretchr/testify/assert"
)

// ==================== GetNotifications Tests ====================

func TestGetNotifications_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewNotificationHandler(db)
	router.GET("/api/v2/notifications", handler.GetNotifications)

	now := time.Now()
	notificationType := "incident_detected"
	deliveryRule := "immediate"

	rows := sqlmock.NewRows([]string{
		"id", "incident_id", "sent_to_staff_ids", "delivery_rule", "sent_at",
		"notification_type", "action_required", "unread_by_staff_ids", "escalated",
	}).
		AddRow("notif-1", "incident-1", pq.StringArray{"staff-1", "staff-2"},
			&deliveryRule, now, &notificationType, true,
			pq.StringArray{"staff-1"}, false)

	mock.ExpectQuery("SELECT (.+) FROM notifications n WHERE 1=1 ORDER BY n.sent_at DESC").
		WillReturnRows(rows)

	req, _ := http.NewRequest("GET", "/api/v2/notifications", nil)
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

func TestGetNotifications_FilterByStaffID(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewNotificationHandler(db)
	router.GET("/api/v2/notifications", handler.GetNotifications)

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

	req, _ := http.NewRequest("GET", "/api/v2/notifications?staffId=staff-1", nil)
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetNotifications_FilterByIncidentID(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewNotificationHandler(db)
	router.GET("/api/v2/notifications", handler.GetNotifications)

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

	req, _ := http.NewRequest("GET", "/api/v2/notifications?incidentId=incident-1", nil)
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetNotifications_UnreadOnly(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewNotificationHandler(db)
	router.GET("/api/v2/notifications", handler.GetNotifications)

	staffID := "staff-1"
	now := time.Now()

	rows := sqlmock.NewRows([]string{
		"id", "incident_id", "sent_to_staff_ids", "delivery_rule", "sent_at",
		"notification_type", "action_required", "unread_by_staff_ids", "escalated",
	}).
		AddRow("notif-1", "incident-1", pq.StringArray{"staff-1"},
			nil, now, nil, true, pq.StringArray{"staff-1"}, false)

	mock.ExpectQuery("SELECT (.+) FROM notifications n WHERE 1=1 AND (.+) = ANY\\(n.sent_to_staff_ids\\) AND (.+) = ANY\\(n.unread_by_staff_ids\\) ORDER BY n.sent_at DESC").
		WithArgs(staffID, staffID).
		WillReturnRows(rows)

	req, _ := http.NewRequest("GET", "/api/v2/notifications?staffId=staff-1&unreadOnly=true", nil)
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetNotifications_DatabaseError(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewNotificationHandler(db)
	router.GET("/api/v2/notifications", handler.GetNotifications)

	mock.ExpectQuery("SELECT (.+) FROM notifications n WHERE 1=1 ORDER BY n.sent_at DESC").
		WillReturnError(sql.ErrConnDone)

	req, _ := http.NewRequest("GET", "/api/v2/notifications", nil)
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusInternalServerError, w.Code)
	assert.NoError(t, mock.ExpectationsWereMet())
}

// ==================== CreateNotification Tests ====================

func TestCreateNotification_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewNotificationHandler(db)
	router.POST("/api/v2/notifications", handler.CreateNotification)

	actionRequired := true
	input := models.NotificationCreate{
		IncidentID:     "incident-1",
		SentToStaffIDs: []string{"staff-1"},
		ActionRequired: &actionRequired,
	}

	now := time.Now()

	mock.ExpectBegin()
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

	mock.ExpectExec("INSERT INTO notification_histories (.+)").
		WithArgs("new-notif-id", "staff-1").
		WillReturnResult(sqlmock.NewResult(1, 1))

	mock.ExpectCommit()

	body, _ := json.Marshal(input)
	req, _ := http.NewRequest("POST", "/api/v2/notifications", bytes.NewBuffer(body))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusCreated, w.Code)

	var response map[string]interface{}
	err = json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)
	assert.True(t, response["success"].(bool))

	data := response["data"].(map[string]interface{})
	assert.Equal(t, "new-notif-id", data["id"])
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestCreateNotification_MissingIncidentID(t *testing.T) {
	db, _, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewNotificationHandler(db)
	router.POST("/api/v2/notifications", handler.CreateNotification)

	input := models.NotificationCreate{
		SentToStaffIDs: []string{"staff-1"},
	}

	body, _ := json.Marshal(input)
	req, _ := http.NewRequest("POST", "/api/v2/notifications", bytes.NewBuffer(body))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusBadRequest, w.Code)

	var response map[string]interface{}
	err = json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)
	assert.False(t, response["success"].(bool))
	assert.Contains(t, response["message"].(string), "incidentId is required")
}

func TestCreateNotification_MissingSentToStaffIDs(t *testing.T) {
	db, _, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewNotificationHandler(db)
	router.POST("/api/v2/notifications", handler.CreateNotification)

	input := models.NotificationCreate{
		IncidentID:     "incident-1",
		SentToStaffIDs: []string{},
	}

	body, _ := json.Marshal(input)
	req, _ := http.NewRequest("POST", "/api/v2/notifications", bytes.NewBuffer(body))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusBadRequest, w.Code)

	var response map[string]interface{}
	err = json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)
	assert.False(t, response["success"].(bool))
	assert.Contains(t, response["message"].(string), "sentToStaffIds")
}

func TestCreateNotification_InvalidJSON(t *testing.T) {
	db, _, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewNotificationHandler(db)
	router.POST("/api/v2/notifications", handler.CreateNotification)

	req, _ := http.NewRequest("POST", "/api/v2/notifications", bytes.NewBuffer([]byte("invalid json")))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusBadRequest, w.Code)
}

func TestCreateNotification_DatabaseError(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewNotificationHandler(db)
	router.POST("/api/v2/notifications", handler.CreateNotification)

	input := models.NotificationCreate{
		IncidentID:     "incident-1",
		SentToStaffIDs: []string{"staff-1"},
	}

	mock.ExpectBegin()
	mock.ExpectQuery("INSERT INTO notifications (.+) RETURNING (.+)").
		WillReturnError(sql.ErrConnDone)
	mock.ExpectRollback()

	body, _ := json.Marshal(input)
	req, _ := http.NewRequest("POST", "/api/v2/notifications", bytes.NewBuffer(body))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusInternalServerError, w.Code)
	assert.NoError(t, mock.ExpectationsWereMet())
}

// ==================== MarkNotificationAsRead Tests ====================

func TestMarkNotificationAsRead_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewNotificationHandler(db)
	router.POST("/api/v2/notifications/:id/mark-read", handler.MarkNotificationAsRead)

	notificationID := "notif-1"
	staffID := "staff-1"

	mock.ExpectBegin()
	mock.ExpectExec("UPDATE notification_histories SET read = true, read_at = CURRENT_TIMESTAMP WHERE notification_id = (.+) AND staff_id = (.+)").
		WithArgs(notificationID, staffID).
		WillReturnResult(sqlmock.NewResult(1, 1))
	mock.ExpectExec("UPDATE notifications SET unread_by_staff_ids = array_remove\\(unread_by_staff_ids, (.+)\\) WHERE id = (.+)").
		WithArgs(staffID, notificationID).
		WillReturnResult(sqlmock.NewResult(1, 1))
	mock.ExpectCommit()

	input := map[string]string{"staffId": staffID}
	body, _ := json.Marshal(input)
	req, _ := http.NewRequest("POST", "/api/v2/notifications/"+notificationID+"/mark-read", bytes.NewBuffer(body))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)

	var response map[string]interface{}
	err = json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)
	assert.True(t, response["success"].(bool))
	assert.Contains(t, response["message"].(string), "successfully")
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestMarkNotificationAsRead_MissingStaffID(t *testing.T) {
	db, _, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewNotificationHandler(db)
	router.POST("/api/v2/notifications/:id/mark-read", handler.MarkNotificationAsRead)

	input := map[string]string{}
	body, _ := json.Marshal(input)
	req, _ := http.NewRequest("POST", "/api/v2/notifications/notif-1/mark-read", bytes.NewBuffer(body))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusBadRequest, w.Code)
}

func TestMarkNotificationAsRead_InvalidJSON(t *testing.T) {
	db, _, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewNotificationHandler(db)
	router.POST("/api/v2/notifications/:id/mark-read", handler.MarkNotificationAsRead)

	req, _ := http.NewRequest("POST", "/api/v2/notifications/notif-1/mark-read", bytes.NewBuffer([]byte("invalid json")))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusBadRequest, w.Code)
}

func TestMarkNotificationAsRead_DatabaseError(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewNotificationHandler(db)
	router.POST("/api/v2/notifications/:id/mark-read", handler.MarkNotificationAsRead)

	notificationID := "notif-1"
	staffID := "staff-1"

	mock.ExpectBegin()
	mock.ExpectExec("UPDATE notification_histories SET read = true, read_at = CURRENT_TIMESTAMP WHERE notification_id = (.+) AND staff_id = (.+)").
		WithArgs(notificationID, staffID).
		WillReturnError(sql.ErrConnDone)
	mock.ExpectRollback()

	input := map[string]string{"staffId": staffID}
	body, _ := json.Marshal(input)
	req, _ := http.NewRequest("POST", "/api/v2/notifications/"+notificationID+"/mark-read", bytes.NewBuffer(body))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusInternalServerError, w.Code)
	assert.NoError(t, mock.ExpectationsWereMet())
}

// ==================== EscalateNotification Tests ====================

func TestEscalateNotification_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewNotificationHandler(db)
	router.POST("/api/v2/notifications/:id/escalate", handler.EscalateNotification)

	notificationID := "notif-1"
	incidentID := "incident-1"

	mock.ExpectBegin()
	mock.ExpectExec("UPDATE notifications SET escalated = true, updated_at = CURRENT_TIMESTAMP WHERE id = (.+)").
		WithArgs(notificationID).
		WillReturnResult(sqlmock.NewResult(1, 1))

	incidentRows := sqlmock.NewRows([]string{"incident_id"}).
		AddRow(incidentID)
	mock.ExpectQuery("SELECT incident_id FROM notifications WHERE id = (.+)").
		WithArgs(notificationID).
		WillReturnRows(incidentRows)

	supervisorRows := sqlmock.NewRows([]string{"id"}).
		AddRow("supervisor-1")
	mock.ExpectQuery("SELECT id FROM staffs WHERE role IN (.+) LIMIT 5").
		WillReturnRows(supervisorRows)

	mock.ExpectExec("INSERT INTO notifications (.+)").
		WithArgs(incidentID, pq.Array([]string{"supervisor-1"})).
		WillReturnResult(sqlmock.NewResult(1, 1))

	mock.ExpectCommit()

	req, _ := http.NewRequest("POST", "/api/v2/notifications/"+notificationID+"/escalate", nil)
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)

	var response map[string]interface{}
	err = json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)
	assert.True(t, response["success"].(bool))
	assert.Contains(t, response["message"].(string), "successfully")
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestEscalateNotification_DatabaseError(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewNotificationHandler(db)
	router.POST("/api/v2/notifications/:id/escalate", handler.EscalateNotification)

	notificationID := "notif-1"

	mock.ExpectBegin()
	mock.ExpectExec("UPDATE notifications SET escalated = true, updated_at = CURRENT_TIMESTAMP WHERE id = (.+)").
		WithArgs(notificationID).
		WillReturnError(sql.ErrConnDone)
	mock.ExpectRollback()

	req, _ := http.NewRequest("POST", "/api/v2/notifications/"+notificationID+"/escalate", nil)
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusInternalServerError, w.Code)
	assert.NoError(t, mock.ExpectationsWereMet())
}
