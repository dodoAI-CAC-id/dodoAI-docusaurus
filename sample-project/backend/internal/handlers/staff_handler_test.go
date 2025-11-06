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

// ==================== GetStaffs Tests ====================

func TestGetStaffs_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewStaffHandler(db)
	router.GET("/api/v2/staffs", handler.GetStaffs)

	now := time.Now()
	departmentID := "dept-1"
	departmentName := "看護部"

	rows := sqlmock.NewRows([]string{
		"id", "name", "department_id", "department_name", "role", "created_at", "updated_at",
	}).
		AddRow("staff-1", "山田太郎", &departmentID, &departmentName, "care", now, now).
		AddRow("staff-2", "佐藤花子", nil, nil, "care", now, now)

	mock.ExpectQuery("SELECT (.+) FROM staffs (.+) LEFT JOIN departments (.+) ORDER BY (.+)name").
		WillReturnRows(rows)

	req, _ := http.NewRequest("GET", "/api/v2/staffs", nil)
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

func TestGetStaffs_EmptyResult(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewStaffHandler(db)
	router.GET("/api/v2/staffs", handler.GetStaffs)

	rows := sqlmock.NewRows([]string{
		"id", "name", "department_id", "department_name", "role", "created_at", "updated_at",
	})

	mock.ExpectQuery("SELECT (.+) FROM staffs (.+) LEFT JOIN departments (.+) ORDER BY (.+)name").
		WillReturnRows(rows)

	req, _ := http.NewRequest("GET", "/api/v2/staffs", nil)
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

func TestGetStaffs_DatabaseError(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewStaffHandler(db)
	router.GET("/api/v2/staffs", handler.GetStaffs)

	mock.ExpectQuery("SELECT (.+) FROM staffs (.+) LEFT JOIN departments (.+) ORDER BY (.+)name").
		WillReturnError(sql.ErrConnDone)

	req, _ := http.NewRequest("GET", "/api/v2/staffs", nil)
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusInternalServerError, w.Code)
	assert.NoError(t, mock.ExpectationsWereMet())
}

// ==================== GetStaff Tests ====================

func TestGetStaff_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewStaffHandler(db)
	router.GET("/api/v2/staffs/:id", handler.GetStaff)

	staffID := "staff-1"
	now := time.Now()
	departmentID := "dept-1"

	departmentName := "看護部"

	rows := sqlmock.NewRows([]string{
		"id", "name", "department_id", "department_name", "role", "created_at", "updated_at",
	}).
		AddRow(staffID, "山田太郎", &departmentID, &departmentName, "care", now, now)

	mock.ExpectQuery("SELECT (.+) FROM staffs (.+) LEFT JOIN departments (.+) WHERE (.+)id = (.+)").
		WithArgs(staffID).
		WillReturnRows(rows)

	req, _ := http.NewRequest("GET", "/api/v2/staffs/"+staffID, nil)
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)

	var response map[string]interface{}
	err = json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)
	assert.True(t, response["success"].(bool))

	data := response["data"].(map[string]interface{})
	assert.Equal(t, staffID, data["id"])
	assert.Equal(t, "山田太郎", data["name"])
	assert.Equal(t, "care", data["role"])
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetStaff_NotFound(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewStaffHandler(db)
	router.GET("/api/v2/staffs/:id", handler.GetStaff)

	staffID := "non-existent"

	mock.ExpectQuery("SELECT (.+) FROM staffs (.+) LEFT JOIN departments (.+) WHERE (.+)id = (.+)").
		WithArgs(staffID).
		WillReturnError(sql.ErrNoRows)

	req, _ := http.NewRequest("GET", "/api/v2/staffs/"+staffID, nil)
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusNotFound, w.Code)

	var response map[string]interface{}
	err = json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)
	assert.False(t, response["success"].(bool))
	assert.Contains(t, response["message"].(string), "Staff not found")
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetStaff_DatabaseError(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewStaffHandler(db)
	router.GET("/api/v2/staffs/:id", handler.GetStaff)

	staffID := "staff-1"

	mock.ExpectQuery("SELECT (.+) FROM staffs (.+) LEFT JOIN departments (.+) WHERE (.+)id = (.+)").
		WithArgs(staffID).
		WillReturnError(sql.ErrConnDone)

	req, _ := http.NewRequest("GET", "/api/v2/staffs/"+staffID, nil)
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusInternalServerError, w.Code)
	assert.NoError(t, mock.ExpectationsWereMet())
}

// ==================== GetDepartments Tests ====================

func TestGetDepartments_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewStaffHandler(db)
	router.GET("/api/v2/departments", handler.GetDepartments)

	now := time.Now()

	rows := sqlmock.NewRows([]string{
		"id", "name", "created_at", "updated_at",
	}).
		AddRow("dept-1", "看護部", now, now).
		AddRow("dept-2", "介護部", now, now)

	mock.ExpectQuery("SELECT (.+) FROM departments ORDER BY name").
		WillReturnRows(rows)

	req, _ := http.NewRequest("GET", "/api/v2/departments", nil)
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

func TestGetDepartments_EmptyResult(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewStaffHandler(db)
	router.GET("/api/v2/departments", handler.GetDepartments)

	rows := sqlmock.NewRows([]string{
		"id", "name", "created_at", "updated_at",
	})

	mock.ExpectQuery("SELECT (.+) FROM departments ORDER BY name").
		WillReturnRows(rows)

	req, _ := http.NewRequest("GET", "/api/v2/departments", nil)
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

func TestGetDepartments_DatabaseError(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewStaffHandler(db)
	router.GET("/api/v2/departments", handler.GetDepartments)

	mock.ExpectQuery("SELECT (.+) FROM departments ORDER BY name").
		WillReturnError(sql.ErrConnDone)

	req, _ := http.NewRequest("GET", "/api/v2/departments", nil)
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusInternalServerError, w.Code)
	assert.NoError(t, mock.ExpectationsWereMet())
}
