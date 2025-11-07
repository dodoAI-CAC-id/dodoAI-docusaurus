package handlers

import (
	"database/sql"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"
	"time"

	"github.com/DATA-DOG/go-sqlmock"
	"github.com/stretchr/testify/assert"
)

// ==================== GetRooms Tests ====================

func TestGetRooms_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewRoomHandler(db)
	router.GET("/api/v2/rooms", handler.GetRooms)

	now := time.Now()
	description := "Test Room"

	rows := sqlmock.NewRows([]string{
		"id", "room_number", "description", "created_at", "updated_at",
	}).
		AddRow("room-1", "101", &description, now, now).
		AddRow("room-2", "102", &description, now, now)

	mock.ExpectQuery("SELECT (.+) FROM rooms ORDER BY room_number").
		WillReturnRows(rows)

	// Mock persons query for room-1
	personRows1 := sqlmock.NewRows([]string{"id"})
	mock.ExpectQuery("SELECT id FROM persons WHERE room_id = (.+)").
		WithArgs("room-1").
		WillReturnRows(personRows1)

	// Mock camera_devices query for room-1
	cameraRows1 := sqlmock.NewRows([]string{"id"})
	mock.ExpectQuery("SELECT id FROM camera_devices WHERE room_id = (.+)").
		WithArgs("room-1").
		WillReturnRows(cameraRows1)

	// Mock persons query for room-2
	personRows2 := sqlmock.NewRows([]string{"id"})
	mock.ExpectQuery("SELECT id FROM persons WHERE room_id = (.+)").
		WithArgs("room-2").
		WillReturnRows(personRows2)

	// Mock camera_devices query for room-2
	cameraRows2 := sqlmock.NewRows([]string{"id"})
	mock.ExpectQuery("SELECT id FROM camera_devices WHERE room_id = (.+)").
		WithArgs("room-2").
		WillReturnRows(cameraRows2)

	req, _ := http.NewRequest("GET", "/api/v2/rooms", nil)
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

func TestGetRooms_EmptyResult(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewRoomHandler(db)
	router.GET("/api/v2/rooms", handler.GetRooms)

	rows := sqlmock.NewRows([]string{
		"id", "room_number", "description", "created_at", "updated_at",
	})

	mock.ExpectQuery("SELECT (.+) FROM rooms ORDER BY room_number").
		WillReturnRows(rows)

	req, _ := http.NewRequest("GET", "/api/v2/rooms", nil)
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

func TestGetRooms_DatabaseError(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewRoomHandler(db)
	router.GET("/api/v2/rooms", handler.GetRooms)

	mock.ExpectQuery("SELECT (.+) FROM rooms ORDER BY room_number").
		WillReturnError(sql.ErrConnDone)

	req, _ := http.NewRequest("GET", "/api/v2/rooms", nil)
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusInternalServerError, w.Code)
	assert.NoError(t, mock.ExpectationsWereMet())
}

// ==================== GetRoom Tests ====================

func TestGetRoom_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewRoomHandler(db)
	router.GET("/api/v2/rooms/:id", handler.GetRoom)

	roomID := "room-1"
	now := time.Now()
	description := "Test Room"

	rows := sqlmock.NewRows([]string{
		"id", "room_number", "description", "created_at", "updated_at",
	}).
		AddRow(roomID, "101", &description, now, now)

	mock.ExpectQuery("SELECT (.+) FROM rooms WHERE id = (.+)").
		WithArgs(roomID).
		WillReturnRows(rows)

	// Mock persons query
	personRows := sqlmock.NewRows([]string{"id"})
	mock.ExpectQuery("SELECT id FROM persons WHERE room_id = (.+)").
		WithArgs(roomID).
		WillReturnRows(personRows)

	// Mock camera_devices query
	cameraRows := sqlmock.NewRows([]string{"id"})
	mock.ExpectQuery("SELECT id FROM camera_devices WHERE room_id = (.+)").
		WithArgs(roomID).
		WillReturnRows(cameraRows)

	req, _ := http.NewRequest("GET", "/api/v2/rooms/"+roomID, nil)
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)

	var response map[string]interface{}
	err = json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)
	assert.True(t, response["success"].(bool))

	data := response["data"].(map[string]interface{})
	assert.Equal(t, roomID, data["id"])
	assert.Equal(t, "101", data["roomNumber"])
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetRoom_NotFound(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewRoomHandler(db)
	router.GET("/api/v2/rooms/:id", handler.GetRoom)

	roomID := "non-existent"

	mock.ExpectQuery("SELECT (.+) FROM rooms WHERE id = (.+)").
		WithArgs(roomID).
		WillReturnError(sql.ErrNoRows)

	req, _ := http.NewRequest("GET", "/api/v2/rooms/"+roomID, nil)
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusNotFound, w.Code)

	var response map[string]interface{}
	err = json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)
	assert.False(t, response["success"].(bool))
	assert.Contains(t, response["message"].(string), "Room not found")
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetRoom_DatabaseError(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewRoomHandler(db)
	router.GET("/api/v2/rooms/:id", handler.GetRoom)

	roomID := "room-1"

	mock.ExpectQuery("SELECT (.+) FROM rooms WHERE id = (.+)").
		WithArgs(roomID).
		WillReturnError(sql.ErrConnDone)

	req, _ := http.NewRequest("GET", "/api/v2/rooms/"+roomID, nil)
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusInternalServerError, w.Code)
	assert.NoError(t, mock.ExpectationsWereMet())
}

// ==================== GetCameraDevices Tests ====================

func TestGetCameraDevices_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewRoomHandler(db)
	router.GET("/api/v2/camera-devices", handler.GetCameraDevices)

	now := time.Now()
	roomID := "room-1"

	rows := sqlmock.NewRows([]string{
		"id", "serial_number", "room_id", "model", "install_date", "status", "created_at", "updated_at",
	}).
		AddRow("camera-1", "CAM-001", &roomID, nil, nil, "normal", now, now).
		AddRow("camera-2", "CAM-002", &roomID, nil, nil, "normal", now, now)

	mock.ExpectQuery("SELECT (.+) FROM camera_devices ORDER BY serial_number").
		WillReturnRows(rows)

	req, _ := http.NewRequest("GET", "/api/v2/camera-devices", nil)
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

func TestGetCameraDevices_EmptyResult(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewRoomHandler(db)
	router.GET("/api/v2/camera-devices", handler.GetCameraDevices)

	rows := sqlmock.NewRows([]string{
		"id", "serial_number", "room_id", "model", "install_date", "status", "created_at", "updated_at",
	})

	mock.ExpectQuery("SELECT (.+) FROM camera_devices ORDER BY serial_number").
		WillReturnRows(rows)

	req, _ := http.NewRequest("GET", "/api/v2/camera-devices", nil)
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

func TestGetCameraDevices_DatabaseError(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewRoomHandler(db)
	router.GET("/api/v2/camera-devices", handler.GetCameraDevices)

	mock.ExpectQuery("SELECT (.+) FROM camera_devices ORDER BY serial_number").
		WillReturnError(sql.ErrConnDone)

	req, _ := http.NewRequest("GET", "/api/v2/camera-devices", nil)
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusInternalServerError, w.Code)
	assert.NoError(t, mock.ExpectationsWereMet())
}

// ==================== GetCameraDevice Tests ====================

func TestGetCameraDevice_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewRoomHandler(db)
	router.GET("/api/v2/camera-devices/:id", handler.GetCameraDevice)

	cameraID := "camera-1"
	now := time.Now()
	roomID := "room-1"

	rows := sqlmock.NewRows([]string{
		"id", "serial_number", "room_id", "model", "install_date", "status", "created_at", "updated_at",
	}).
		AddRow(cameraID, "CAM-001", &roomID, nil, nil, "normal", now, now)

	mock.ExpectQuery("SELECT (.+) FROM camera_devices WHERE id = (.+)").
		WithArgs(cameraID).
		WillReturnRows(rows)

	req, _ := http.NewRequest("GET", "/api/v2/camera-devices/"+cameraID, nil)
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)

	var response map[string]interface{}
	err = json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)
	assert.True(t, response["success"].(bool))

	data := response["data"].(map[string]interface{})
	assert.Equal(t, cameraID, data["id"])
	assert.Equal(t, "CAM-001", data["serialNumber"])
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetCameraDevice_NotFound(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewRoomHandler(db)
	router.GET("/api/v2/camera-devices/:id", handler.GetCameraDevice)

	cameraID := "non-existent"

	mock.ExpectQuery("SELECT (.+) FROM camera_devices WHERE id = (.+)").
		WithArgs(cameraID).
		WillReturnError(sql.ErrNoRows)

	req, _ := http.NewRequest("GET", "/api/v2/camera-devices/"+cameraID, nil)
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusNotFound, w.Code)

	var response map[string]interface{}
	err = json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)
	assert.False(t, response["success"].(bool))
	assert.Contains(t, response["message"].(string), "Camera device not found")
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetCameraDevice_DatabaseError(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewRoomHandler(db)
	router.GET("/api/v2/camera-devices/:id", handler.GetCameraDevice)

	cameraID := "camera-1"

	mock.ExpectQuery("SELECT (.+) FROM camera_devices WHERE id = (.+)").
		WithArgs(cameraID).
		WillReturnError(sql.ErrConnDone)

	req, _ := http.NewRequest("GET", "/api/v2/camera-devices/"+cameraID, nil)
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusInternalServerError, w.Code)
	assert.NoError(t, mock.ExpectationsWereMet())
}

// ==================== GetDetectionAreas Tests ====================

func TestGetDetectionAreas_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewRoomHandler(db)
	router.GET("/api/v2/detection-areas", handler.GetDetectionAreas)

	now := time.Now()
	cameraID := "camera-1"

	rows := sqlmock.NewRows([]string{
		"id", "camera_id", "name", "area_shape", "created_at", "updated_at",
	}).
		AddRow("area-1", cameraID, "Bed Area", nil, now, now).
		AddRow("area-2", cameraID, "Bathroom Area", nil, now, now)

	mock.ExpectQuery("SELECT (.+) FROM detection_areas WHERE 1=1 ORDER BY name").
		WillReturnRows(rows)

	req, _ := http.NewRequest("GET", "/api/v2/detection-areas", nil)
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

func TestGetDetectionAreas_FilterByCameraID(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewRoomHandler(db)
	router.GET("/api/v2/detection-areas", handler.GetDetectionAreas)

	now := time.Now()
	cameraID := "camera-1"

	rows := sqlmock.NewRows([]string{
		"id", "camera_id", "name", "area_shape", "created_at", "updated_at",
	}).
		AddRow("area-1", cameraID, "Bed Area", nil, now, now)

	mock.ExpectQuery("SELECT (.+) FROM detection_areas WHERE 1=1 AND camera_id = (.+) ORDER BY name").
		WithArgs(cameraID).
		WillReturnRows(rows)

	req, _ := http.NewRequest("GET", "/api/v2/detection-areas?cameraId=camera-1", nil)
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

func TestGetDetectionAreas_EmptyResult(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewRoomHandler(db)
	router.GET("/api/v2/detection-areas", handler.GetDetectionAreas)

	rows := sqlmock.NewRows([]string{
		"id", "camera_id", "name", "area_shape", "created_at", "updated_at",
	})

	mock.ExpectQuery("SELECT (.+) FROM detection_areas WHERE 1=1 ORDER BY name").
		WillReturnRows(rows)

	req, _ := http.NewRequest("GET", "/api/v2/detection-areas", nil)
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

func TestGetDetectionAreas_DatabaseError(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewRoomHandler(db)
	router.GET("/api/v2/detection-areas", handler.GetDetectionAreas)

	mock.ExpectQuery("SELECT (.+) FROM detection_areas WHERE 1=1 ORDER BY name").
		WillReturnError(sql.ErrConnDone)

	req, _ := http.NewRequest("GET", "/api/v2/detection-areas", nil)
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusInternalServerError, w.Code)
	assert.NoError(t, mock.ExpectationsWereMet())
}
