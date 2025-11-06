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

// ==================== GetPersons Tests ====================

func TestGetPersons_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewPersonHandler(db)
	router.GET("/api/v2/persons", handler.GetPersons)

	now := time.Now()
	birthday := time.Date(1950, 1, 1, 0, 0, 0, 0, time.UTC)
	kana := "ヤマダタロウ"
	roomID := "room-1"

	rows := sqlmock.NewRows([]string{
		"id", "name", "kana", "birthday", "gender", "room_id", "memo", "created_at", "updated_at",
	}).
		AddRow("person-1", "山田太郎", &kana, &birthday, "male", &roomID, nil, now, now).
		AddRow("person-2", "佐藤花子", nil, nil, "female", nil, nil, now, now)

	mock.ExpectQuery("SELECT (.+) FROM persons ORDER BY name").
		WillReturnRows(rows)

	req, _ := http.NewRequest("GET", "/api/v2/persons", nil)
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

func TestGetPersons_EmptyResult(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewPersonHandler(db)
	router.GET("/api/v2/persons", handler.GetPersons)

	rows := sqlmock.NewRows([]string{
		"id", "name", "kana", "birthday", "gender", "room_id", "memo", "created_at", "updated_at",
	})

	mock.ExpectQuery("SELECT (.+) FROM persons ORDER BY name").
		WillReturnRows(rows)

	req, _ := http.NewRequest("GET", "/api/v2/persons", nil)
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

func TestGetPersons_DatabaseError(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewPersonHandler(db)
	router.GET("/api/v2/persons", handler.GetPersons)

	mock.ExpectQuery("SELECT (.+) FROM persons ORDER BY name").
		WillReturnError(sql.ErrConnDone)

	req, _ := http.NewRequest("GET", "/api/v2/persons", nil)
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusInternalServerError, w.Code)
	assert.NoError(t, mock.ExpectationsWereMet())
}

// ==================== GetPerson Tests ====================

func TestGetPerson_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewPersonHandler(db)
	router.GET("/api/v2/persons/:id", handler.GetPerson)

	personID := "person-1"
	now := time.Now()
	birthday := time.Date(1950, 1, 1, 0, 0, 0, 0, time.UTC)
	kana := "ヤマダタロウ"
	roomID := "room-1"

	rows := sqlmock.NewRows([]string{
		"id", "name", "kana", "birthday", "gender", "room_id", "memo", "created_at", "updated_at",
	}).
		AddRow(personID, "山田太郎", &kana, &birthday, "male", &roomID, nil, now, now)

	mock.ExpectQuery("SELECT (.+) FROM persons WHERE id = (.+)").
		WithArgs(personID).
		WillReturnRows(rows)

	req, _ := http.NewRequest("GET", "/api/v2/persons/"+personID, nil)
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)

	var response map[string]interface{}
	err = json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)
	assert.True(t, response["success"].(bool))

	data := response["data"].(map[string]interface{})
	assert.Equal(t, personID, data["id"])
	assert.Equal(t, "山田太郎", data["name"])
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetPerson_NotFound(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewPersonHandler(db)
	router.GET("/api/v2/persons/:id", handler.GetPerson)

	personID := "non-existent"

	mock.ExpectQuery("SELECT (.+) FROM persons WHERE id = (.+)").
		WithArgs(personID).
		WillReturnError(sql.ErrNoRows)

	req, _ := http.NewRequest("GET", "/api/v2/persons/"+personID, nil)
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusNotFound, w.Code)

	var response map[string]interface{}
	err = json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)
	assert.False(t, response["success"].(bool))
	assert.Contains(t, response["message"].(string), "Person not found")
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetPerson_DatabaseError(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewPersonHandler(db)
	router.GET("/api/v2/persons/:id", handler.GetPerson)

	personID := "person-1"

	mock.ExpectQuery("SELECT (.+) FROM persons WHERE id = (.+)").
		WithArgs(personID).
		WillReturnError(sql.ErrConnDone)

	req, _ := http.NewRequest("GET", "/api/v2/persons/"+personID, nil)
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusInternalServerError, w.Code)
	assert.NoError(t, mock.ExpectationsWereMet())
}

// ==================== CreatePerson Tests ====================

func TestCreatePerson_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewPersonHandler(db)
	router.POST("/api/v2/persons", handler.CreatePerson)

	gender := "male"
	input := models.PersonCreate{
		Name:   "山田太郎",
		Gender: &gender,
	}

	now := time.Now()

	rows := sqlmock.NewRows([]string{
		"id", "name", "kana", "birthday", "gender", "room_id", "memo", "created_at", "updated_at",
	}).
		AddRow("new-person-id", input.Name, nil, nil, gender, nil, nil, now, now)

	mock.ExpectQuery("INSERT INTO persons (.+) RETURNING (.+)").
		WithArgs(input.Name, input.Kana, input.Birthday, gender, input.RoomID, input.Memo).
		WillReturnRows(rows)

	body, _ := json.Marshal(input)
	req, _ := http.NewRequest("POST", "/api/v2/persons", bytes.NewBuffer(body))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusCreated, w.Code)

	var response map[string]interface{}
	err = json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)
	assert.True(t, response["success"].(bool))

	data := response["data"].(map[string]interface{})
	assert.Equal(t, "new-person-id", data["id"])
	assert.Equal(t, "山田太郎", data["name"])
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestCreatePerson_MissingName(t *testing.T) {
	db, _, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewPersonHandler(db)
	router.POST("/api/v2/persons", handler.CreatePerson)

	gender := "male"
	input := models.PersonCreate{
		Gender: &gender,
	}

	body, _ := json.Marshal(input)
	req, _ := http.NewRequest("POST", "/api/v2/persons", bytes.NewBuffer(body))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusBadRequest, w.Code)

	var response map[string]interface{}
	err = json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)
	assert.False(t, response["success"].(bool))
	assert.Contains(t, response["message"].(string), "name is required")
}

func TestCreatePerson_InvalidJSON(t *testing.T) {
	db, _, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewPersonHandler(db)
	router.POST("/api/v2/persons", handler.CreatePerson)

	req, _ := http.NewRequest("POST", "/api/v2/persons", bytes.NewBuffer([]byte("invalid json")))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusBadRequest, w.Code)
}

func TestCreatePerson_DatabaseError(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewPersonHandler(db)
	router.POST("/api/v2/persons", handler.CreatePerson)

	input := models.PersonCreate{
		Name: "山田太郎",
	}

	mock.ExpectQuery("INSERT INTO persons (.+) RETURNING (.+)").
		WithArgs(input.Name, input.Kana, input.Birthday, "unknown", input.RoomID, input.Memo).
		WillReturnError(sql.ErrConnDone)

	body, _ := json.Marshal(input)
	req, _ := http.NewRequest("POST", "/api/v2/persons", bytes.NewBuffer(body))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusInternalServerError, w.Code)
	assert.NoError(t, mock.ExpectationsWereMet())
}

// ==================== UpdatePerson Tests ====================

func TestUpdatePerson_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewPersonHandler(db)
	router.PATCH("/api/v2/persons/:id", handler.UpdatePerson)

	personID := "person-1"
	name := "山田太郎（更新）"
	gender := "male"

	input := models.PersonUpdate{
		Name:   &name,
		Gender: &gender,
	}

	now := time.Now()

	rows := sqlmock.NewRows([]string{
		"id", "name", "kana", "birthday", "gender", "room_id", "memo", "created_at", "updated_at",
	}).
		AddRow(personID, name, nil, nil, gender, nil, nil, now, now)

	mock.ExpectQuery("UPDATE persons SET (.+) WHERE id = (.+) RETURNING (.+)").
		WithArgs(name, gender, personID).
		WillReturnRows(rows)

	body, _ := json.Marshal(input)
	req, _ := http.NewRequest("PATCH", "/api/v2/persons/"+personID, bytes.NewBuffer(body))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)

	var response map[string]interface{}
	err = json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)
	assert.True(t, response["success"].(bool))

	data := response["data"].(map[string]interface{})
	assert.Equal(t, personID, data["id"])
	assert.Equal(t, name, data["name"])
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestUpdatePerson_NotFound(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewPersonHandler(db)
	router.PATCH("/api/v2/persons/:id", handler.UpdatePerson)

	personID := "non-existent"
	name := "Test"

	input := models.PersonUpdate{
		Name: &name,
	}

	mock.ExpectQuery("UPDATE persons SET (.+) WHERE id = (.+) RETURNING (.+)").
		WithArgs(name, personID).
		WillReturnError(sql.ErrNoRows)

	body, _ := json.Marshal(input)
	req, _ := http.NewRequest("PATCH", "/api/v2/persons/"+personID, bytes.NewBuffer(body))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusNotFound, w.Code)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestUpdatePerson_InvalidJSON(t *testing.T) {
	db, _, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewPersonHandler(db)
	router.PATCH("/api/v2/persons/:id", handler.UpdatePerson)

	personID := "person-1"

	req, _ := http.NewRequest("PATCH", "/api/v2/persons/"+personID, bytes.NewBuffer([]byte("invalid json")))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusBadRequest, w.Code)
}

// ==================== DeletePerson Tests ====================

func TestDeletePerson_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewPersonHandler(db)
	router.DELETE("/api/v2/persons/:id", handler.DeletePerson)

	personID := "person-1"

	mock.ExpectExec("DELETE FROM persons WHERE id = (.+)").
		WithArgs(personID).
		WillReturnResult(sqlmock.NewResult(0, 1))

	req, _ := http.NewRequest("DELETE", "/api/v2/persons/"+personID, nil)
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

func TestDeletePerson_NotFound(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewPersonHandler(db)
	router.DELETE("/api/v2/persons/:id", handler.DeletePerson)

	personID := "non-existent"

	mock.ExpectExec("DELETE FROM persons WHERE id = (.+)").
		WithArgs(personID).
		WillReturnResult(sqlmock.NewResult(0, 0))

	req, _ := http.NewRequest("DELETE", "/api/v2/persons/"+personID, nil)
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusNotFound, w.Code)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestDeletePerson_DatabaseError(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	router := setupTestRouter()
	handler := NewPersonHandler(db)
	router.DELETE("/api/v2/persons/:id", handler.DeletePerson)

	personID := "person-1"

	mock.ExpectExec("DELETE FROM persons WHERE id = (.+)").
		WithArgs(personID).
		WillReturnError(sql.ErrConnDone)

	req, _ := http.NewRequest("DELETE", "/api/v2/persons/"+personID, nil)
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusInternalServerError, w.Code)
	assert.NoError(t, mock.ExpectationsWereMet())
}
