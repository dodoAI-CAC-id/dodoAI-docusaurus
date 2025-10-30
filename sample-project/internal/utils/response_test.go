package utils

import (
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
)

// テスト用のGinコンテキストを作成するヘルパー関数
func setupTestContext() (*gin.Context, *httptest.ResponseRecorder) {
	gin.SetMode(gin.TestMode)
	w := httptest.NewRecorder()
	c, _ := gin.CreateTestContext(w)
	return c, w
}

// TestErrorResponse_Success は ErrorResponse 関数が正しいエラーレスポンスを返すことを確認
func TestErrorResponse_Success(t *testing.T) {
	// Arrange
	c, w := setupTestContext()
	expectedStatusCode := http.StatusBadRequest
	expectedMessage := "Invalid request parameters"

	// Act
	ErrorResponse(c, expectedStatusCode, expectedMessage)

	// Assert
	assert.Equal(t, expectedStatusCode, w.Code, "ステータスコードが一致すること")

	var response map[string]interface{}
	err := json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err, "JSONのパースに成功すること")
	assert.Equal(t, false, response["success"], "success フィールドが false であること")
	assert.Equal(t, expectedMessage, response["message"], "message フィールドが一致すること")
	assert.NotContains(t, response, "data", "data フィールドが含まれないこと")
}

// TestErrorResponse_InternalServerError は 500 エラーのレスポンスを確認
func TestErrorResponse_InternalServerError(t *testing.T) {
	// Arrange
	c, w := setupTestContext()
	expectedStatusCode := http.StatusInternalServerError
	expectedMessage := "Internal server error occurred"

	// Act
	ErrorResponse(c, expectedStatusCode, expectedMessage)

	// Assert
	assert.Equal(t, expectedStatusCode, w.Code)

	var response map[string]interface{}
	err := json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)
	assert.Equal(t, false, response["success"])
	assert.Equal(t, expectedMessage, response["message"])
}

// TestErrorResponse_NotFound は 404 エラーのレスポンスを確認
func TestErrorResponse_NotFound(t *testing.T) {
	// Arrange
	c, w := setupTestContext()
	expectedStatusCode := http.StatusNotFound
	expectedMessage := "Resource not found"

	// Act
	ErrorResponse(c, expectedStatusCode, expectedMessage)

	// Assert
	assert.Equal(t, expectedStatusCode, w.Code)

	var response map[string]interface{}
	err := json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)
	assert.Equal(t, false, response["success"])
	assert.Equal(t, expectedMessage, response["message"])
}

// TestSuccessResponse_WithSimpleData はシンプルなデータでの成功レスポンスを確認
func TestSuccessResponse_WithSimpleData(t *testing.T) {
	// Arrange
	c, w := setupTestContext()
	expectedStatusCode := http.StatusOK
	expectedData := map[string]interface{}{
		"id":   "123",
		"name": "Test User",
	}

	// Act
	SuccessResponse(c, expectedStatusCode, expectedData)

	// Assert
	assert.Equal(t, expectedStatusCode, w.Code)

	var response map[string]interface{}
	err := json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)
	assert.Equal(t, true, response["success"], "success フィールドが true であること")
	assert.Contains(t, response, "data", "data フィールドが含まれること")

	data, ok := response["data"].(map[string]interface{})
	assert.True(t, ok, "data が map として取得できること")
	assert.Equal(t, expectedData["id"], data["id"])
	assert.Equal(t, expectedData["name"], data["name"])
}

// TestSuccessResponse_WithArrayData は配列データでの成功レスポンスを確認
func TestSuccessResponse_WithArrayData(t *testing.T) {
	// Arrange
	c, w := setupTestContext()
	expectedStatusCode := http.StatusOK
	expectedData := []map[string]interface{}{
		{"id": "1", "name": "Item 1"},
		{"id": "2", "name": "Item 2"},
	}

	// Act
	SuccessResponse(c, expectedStatusCode, expectedData)

	// Assert
	assert.Equal(t, expectedStatusCode, w.Code)

	var response map[string]interface{}
	err := json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)
	assert.Equal(t, true, response["success"])
	assert.Contains(t, response, "data")

	data, ok := response["data"].([]interface{})
	assert.True(t, ok, "data が配列として取得できること")
	assert.Len(t, data, 2, "data の要素数が 2 であること")
}

// TestSuccessResponse_WithCreatedStatus は 201 Created ステータスでの成功レスポンスを確認
func TestSuccessResponse_WithCreatedStatus(t *testing.T) {
	// Arrange
	c, w := setupTestContext()
	expectedStatusCode := http.StatusCreated
	expectedData := map[string]interface{}{
		"id":      "new-123",
		"message": "Resource created successfully",
	}

	// Act
	SuccessResponse(c, expectedStatusCode, expectedData)

	// Assert
	assert.Equal(t, expectedStatusCode, w.Code)

	var response map[string]interface{}
	err := json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)
	assert.Equal(t, true, response["success"])
	assert.Contains(t, response, "data")
}

// TestSuccessResponse_WithNilData は nil データでの成功レスポンスを確認
func TestSuccessResponse_WithNilData(t *testing.T) {
	// Arrange
	c, w := setupTestContext()
	expectedStatusCode := http.StatusOK

	// Act
	SuccessResponse(c, expectedStatusCode, nil)

	// Assert
	assert.Equal(t, expectedStatusCode, w.Code)

	var response map[string]interface{}
	err := json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)
	assert.Equal(t, true, response["success"])
	assert.Contains(t, response, "data")
	assert.Nil(t, response["data"], "data が nil であること")
}

// TestMessageResponse_Success はメッセージレスポンスが正しく返されることを確認
func TestMessageResponse_Success(t *testing.T) {
	// Arrange
	c, w := setupTestContext()
	expectedStatusCode := http.StatusOK
	expectedMessage := "Operation completed successfully"

	// Act
	MessageResponse(c, expectedStatusCode, expectedMessage)

	// Assert
	assert.Equal(t, expectedStatusCode, w.Code)

	var response map[string]interface{}
	err := json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)
	assert.Equal(t, true, response["success"], "success フィールドが true であること")
	assert.Equal(t, expectedMessage, response["message"], "message フィールドが一致すること")
	assert.NotContains(t, response, "data", "data フィールドが含まれないこと")
}

// TestMessageResponse_WithOKStatus は 200 OK ステータスでのメッセージレスポンスを確認
func TestMessageResponse_WithOKStatus(t *testing.T) {
	// Arrange
	c, w := setupTestContext()
	expectedStatusCode := http.StatusOK
	expectedMessage := "Resource deleted successfully"

	// Act
	MessageResponse(c, expectedStatusCode, expectedMessage)

	// Assert
	assert.Equal(t, expectedStatusCode, w.Code)

	var response map[string]interface{}
	err := json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)
	assert.Equal(t, true, response["success"])
	assert.Equal(t, expectedMessage, response["message"])
}

// TestMessageResponse_WithAcceptedStatus は 202 Accepted ステータスでのメッセージレスポンスを確認
func TestMessageResponse_WithAcceptedStatus(t *testing.T) {
	// Arrange
	c, w := setupTestContext()
	expectedStatusCode := http.StatusAccepted
	expectedMessage := "Request accepted for processing"

	// Act
	MessageResponse(c, expectedStatusCode, expectedMessage)

	// Assert
	assert.Equal(t, expectedStatusCode, w.Code)

	var response map[string]interface{}
	err := json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)
	assert.Equal(t, true, response["success"])
	assert.Equal(t, expectedMessage, response["message"])
}

// テーブル駆動テスト - 様々なステータスコードでのエラーレスポンス
func TestErrorResponse_VariousStatusCodes(t *testing.T) {
	tests := []struct {
		name       string
		statusCode int
		message    string
	}{
		{
			name:       "Bad Request",
			statusCode: http.StatusBadRequest,
			message:    "Bad request error",
		},
		{
			name:       "Unauthorized",
			statusCode: http.StatusUnauthorized,
			message:    "Unauthorized access",
		},
		{
			name:       "Forbidden",
			statusCode: http.StatusForbidden,
			message:    "Access forbidden",
		},
		{
			name:       "Conflict",
			statusCode: http.StatusConflict,
			message:    "Resource conflict",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			// Arrange
			c, w := setupTestContext()

			// Act
			ErrorResponse(c, tt.statusCode, tt.message)

			// Assert
			assert.Equal(t, tt.statusCode, w.Code)

			var response map[string]interface{}
			err := json.Unmarshal(w.Body.Bytes(), &response)
			assert.NoError(t, err)
			assert.Equal(t, false, response["success"])
			assert.Equal(t, tt.message, response["message"])
		})
	}
}
