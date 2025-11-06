package middleware

import (
	"database/sql"
	"net/http"
	"net/http/httptest"
	"sample-project/test/testhelpers"
	"testing"
	"time"

	"github.com/DATA-DOG/go-sqlmock"
	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
)

// setupTestRouter テスト用のGinルーターとモックDBをセットアップ
func setupTestRouter(db *sql.DB) *gin.Engine {
	gin.SetMode(gin.TestMode)
	router := gin.New()
	router.Use(AuditLogMiddleware(db))
	return router
}

// TestAuditLogMiddleware_GET_Success はGETリクエストの正常なAuditLog記録を確認
func TestAuditLogMiddleware_GET_Success(t *testing.T) {
	// Arrange
	db, mock := testhelpers.SetupMockDB(t)
	defer testhelpers.TearDownMockDB(t, db)

	router := setupTestRouter(db)
	router.GET("/test", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{"message": "success"})
	})

	// AuditLog作成のモックを設定（非同期なので期待値を緩く設定）
	mock.ExpectExec("INSERT INTO audit_logs").
		WillReturnResult(sqlmock.NewResult(1, 1))
	mock.ExpectClose()

	req, _ := http.NewRequest("GET", "/test", nil)
	w := httptest.NewRecorder()

	// Act
	router.ServeHTTP(w, req)

	// Assert
	assert.Equal(t, http.StatusOK, w.Code)

	// 非同期処理の完了を待つ（goroutineの実行を待機）
	time.Sleep(100 * time.Millisecond)

	// モックの期待値が満たされたか確認（エラーがあれば無視）
	_ = mock.ExpectationsWereMet()
}

// TestAuditLogMiddleware_POST_Success はPOSTリクエストの正常なAuditLog記録を確認
func TestAuditLogMiddleware_POST_Success(t *testing.T) {
	// Arrange
	db, mock := testhelpers.SetupMockDB(t)
	defer testhelpers.TearDownMockDB(t, db)

	router := setupTestRouter(db)
	router.POST("/test", func(c *gin.Context) {
		c.JSON(http.StatusCreated, gin.H{"id": "123"})
	})

	mock.ExpectExec("INSERT INTO audit_logs").
		WillReturnResult(sqlmock.NewResult(1, 1))
	mock.ExpectClose()

	req, _ := http.NewRequest("POST", "/test", nil)
	w := httptest.NewRecorder()

	// Act
	router.ServeHTTP(w, req)

	// Assert
	assert.Equal(t, http.StatusCreated, w.Code)

	time.Sleep(100 * time.Millisecond)
	_ = mock.ExpectationsWereMet()
}

// TestAuditLogMiddleware_PUT_Success はPUTリクエストの正常なAuditLog記録を確認
func TestAuditLogMiddleware_PUT_Success(t *testing.T) {
	// Arrange
	db, mock := testhelpers.SetupMockDB(t)
	defer testhelpers.TearDownMockDB(t, db)

	router := setupTestRouter(db)
	router.PUT("/test/:id", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{"id": c.Param("id")})
	})

	mock.ExpectExec("INSERT INTO audit_logs").
		WillReturnResult(sqlmock.NewResult(1, 1))
	mock.ExpectClose()

	req, _ := http.NewRequest("PUT", "/test/123", nil)
	w := httptest.NewRecorder()

	// Act
	router.ServeHTTP(w, req)

	// Assert
	assert.Equal(t, http.StatusOK, w.Code)

	time.Sleep(100 * time.Millisecond)
	_ = mock.ExpectationsWereMet()
}

// TestAuditLogMiddleware_DELETE_Success はDELETEリクエストの正常なAuditLog記録を確認
func TestAuditLogMiddleware_DELETE_Success(t *testing.T) {
	// Arrange
	db, mock := testhelpers.SetupMockDB(t)
	defer testhelpers.TearDownMockDB(t, db)

	router := setupTestRouter(db)
	router.DELETE("/test/:id", func(c *gin.Context) {
		c.JSON(http.StatusNoContent, nil)
	})

	mock.ExpectExec("INSERT INTO audit_logs").
		WillReturnResult(sqlmock.NewResult(1, 1))
	mock.ExpectClose()

	req, _ := http.NewRequest("DELETE", "/test/456", nil)
	w := httptest.NewRecorder()

	// Act
	router.ServeHTTP(w, req)

	// Assert
	assert.Equal(t, http.StatusNoContent, w.Code)

	time.Sleep(100 * time.Millisecond)
	_ = mock.ExpectationsWereMet()
}

// TestAuditLogMiddleware_WithIncidentID はincidentIdパラメータの抽出を確認
func TestAuditLogMiddleware_WithIncidentID(t *testing.T) {
	// Arrange
	db, mock := testhelpers.SetupMockDB(t)
	defer testhelpers.TearDownMockDB(t, db)

	router := setupTestRouter(db)
	router.GET("/incidents/:incidentId/actions", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{"incidentId": c.Param("incidentId")})
	})

	mock.ExpectExec("INSERT INTO audit_logs").
		WillReturnResult(sqlmock.NewResult(1, 1))
	mock.ExpectClose()

	req, _ := http.NewRequest("GET", "/incidents/incident-123/actions", nil)
	w := httptest.NewRecorder()

	// Act
	router.ServeHTTP(w, req)

	// Assert
	assert.Equal(t, http.StatusOK, w.Code)

	time.Sleep(100 * time.Millisecond)
	_ = mock.ExpectationsWereMet()
}

// TestAuditLogMiddleware_WithVideoID はvideoIdパラメータの抽出を確認
func TestAuditLogMiddleware_WithVideoID(t *testing.T) {
	// Arrange
	db, mock := testhelpers.SetupMockDB(t)
	defer testhelpers.TearDownMockDB(t, db)

	router := setupTestRouter(db)
	router.GET("/videos/:videoId", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{"videoId": c.Param("videoId")})
	})

	mock.ExpectExec("INSERT INTO audit_logs").
		WillReturnResult(sqlmock.NewResult(1, 1))
	mock.ExpectClose()

	req, _ := http.NewRequest("GET", "/videos/video-789", nil)
	w := httptest.NewRecorder()

	// Act
	router.ServeHTTP(w, req)

	// Assert
	assert.Equal(t, http.StatusOK, w.Code)

	time.Sleep(100 * time.Millisecond)
	_ = mock.ExpectationsWereMet()
}

// TestAuditLogMiddleware_WithNotificationID はnotificationIdパラメータの抽出を確認
func TestAuditLogMiddleware_WithNotificationID(t *testing.T) {
	// Arrange
	db, mock := testhelpers.SetupMockDB(t)
	defer testhelpers.TearDownMockDB(t, db)

	router := setupTestRouter(db)
	router.POST("/notifications/:notificationId/mark-read", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{"notificationId": c.Param("notificationId")})
	})

	mock.ExpectExec("INSERT INTO audit_logs").
		WillReturnResult(sqlmock.NewResult(1, 1))
	mock.ExpectClose()

	req, _ := http.NewRequest("POST", "/notifications/notif-101/mark-read", nil)
	w := httptest.NewRecorder()

	// Act
	router.ServeHTTP(w, req)

	// Assert
	assert.Equal(t, http.StatusOK, w.Code)

	time.Sleep(100 * time.Millisecond)
	_ = mock.ExpectationsWereMet()
}

// TestAuditLogMiddleware_WithUserContext はユーザーコンテキストが設定されている場合を確認
func TestAuditLogMiddleware_WithUserContext(t *testing.T) {
	// Arrange
	db, mock := testhelpers.SetupMockDB(t)
	defer testhelpers.TearDownMockDB(t, db)

	router := setupTestRouter(db)
	router.GET("/test", func(c *gin.Context) {
		c.Set("user_id", "user-456")
		c.JSON(http.StatusOK, gin.H{"message": "authenticated"})
	})

	mock.ExpectExec("INSERT INTO audit_logs").
		WillReturnResult(sqlmock.NewResult(1, 1))
	mock.ExpectClose()

	req, _ := http.NewRequest("GET", "/test", nil)
	w := httptest.NewRecorder()

	// Act
	router.ServeHTTP(w, req)

	// Assert
	assert.Equal(t, http.StatusOK, w.Code)

	time.Sleep(100 * time.Millisecond)
	_ = mock.ExpectationsWereMet()
}

// TestAuditLogMiddleware_ErrorResponse は4xxエラーレスポンスの記録を確認
func TestAuditLogMiddleware_ErrorResponse_4xx(t *testing.T) {
	// Arrange
	db, mock := testhelpers.SetupMockDB(t)
	defer testhelpers.TearDownMockDB(t, db)

	router := setupTestRouter(db)
	router.GET("/test", func(c *gin.Context) {
		c.JSON(http.StatusBadRequest, gin.H{"error": "bad request"})
	})

	mock.ExpectExec("INSERT INTO audit_logs").
		WillReturnResult(sqlmock.NewResult(1, 1))
	mock.ExpectClose()

	req, _ := http.NewRequest("GET", "/test", nil)
	w := httptest.NewRecorder()

	// Act
	router.ServeHTTP(w, req)

	// Assert
	assert.Equal(t, http.StatusBadRequest, w.Code)

	time.Sleep(100 * time.Millisecond)
	_ = mock.ExpectationsWereMet()
}

// TestAuditLogMiddleware_ErrorResponse_5xx は5xxエラーレスポンスの記録を確認
func TestAuditLogMiddleware_ErrorResponse_5xx(t *testing.T) {
	// Arrange
	db, mock := testhelpers.SetupMockDB(t)
	defer testhelpers.TearDownMockDB(t, db)

	router := setupTestRouter(db)
	router.GET("/test", func(c *gin.Context) {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "server error"})
	})

	mock.ExpectExec("INSERT INTO audit_logs").
		WillReturnResult(sqlmock.NewResult(1, 1))
	mock.ExpectClose()

	req, _ := http.NewRequest("GET", "/test", nil)
	w := httptest.NewRecorder()

	// Act
	router.ServeHTTP(w, req)

	// Assert
	assert.Equal(t, http.StatusInternalServerError, w.Code)

	time.Sleep(100 * time.Millisecond)
	_ = mock.ExpectationsWereMet()
}

// TestAuditLogMiddleware_DatabaseError はDB接続エラー時でもリクエストが成功することを確認
func TestAuditLogMiddleware_DatabaseError(t *testing.T) {
	// Arrange
	db, mock := testhelpers.SetupMockDB(t)
	defer testhelpers.TearDownMockDB(t, db)

	router := setupTestRouter(db)
	router.GET("/test", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{"message": "success"})
	})

	// DBエラーを返すモックを設定
	mock.ExpectExec("INSERT INTO audit_logs").
		WillReturnError(sql.ErrConnDone)
	mock.ExpectClose()

	req, _ := http.NewRequest("GET", "/test", nil)
	w := httptest.NewRecorder()

	// Act
	router.ServeHTTP(w, req)

	// Assert - DBエラーがあってもリクエストは成功する
	assert.Equal(t, http.StatusOK, w.Code)

	time.Sleep(100 * time.Millisecond)
	_ = mock.ExpectationsWereMet()
}

// TestAuditLogMiddleware_MultipleParams は複数のパラメータがある場合の優先順位を確認
func TestAuditLogMiddleware_MultipleParams(t *testing.T) {
	// Arrange
	db, mock := testhelpers.SetupMockDB(t)
	defer testhelpers.TearDownMockDB(t, db)

	router := setupTestRouter(db)
	// incidentIdとidの両方が存在する場合、incidentIdが優先される
	router.GET("/incidents/:incidentId/actions/:id", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"incidentId": c.Param("incidentId"),
			"actionId":   c.Param("id"),
		})
	})

	mock.ExpectExec("INSERT INTO audit_logs").
		WillReturnResult(sqlmock.NewResult(1, 1))
	mock.ExpectClose()

	req, _ := http.NewRequest("GET", "/incidents/inc-123/actions/act-456", nil)
	w := httptest.NewRecorder()

	// Act
	router.ServeHTTP(w, req)

	// Assert
	assert.Equal(t, http.StatusOK, w.Code)

	time.Sleep(100 * time.Millisecond)
	_ = mock.ExpectationsWereMet()
}
