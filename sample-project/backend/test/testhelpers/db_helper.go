package testhelpers

import (
	"database/sql"
	"testing"

	"github.com/DATA-DOG/go-sqlmock"
)

// SetupMockDB creates a mock database connection for testing
func SetupMockDB(t *testing.T) (*sql.DB, sqlmock.Sqlmock) {
	db, mock, err := sqlmock.New()
	if err != nil {
		t.Fatalf("Failed to create mock database: %v", err)
	}
	return db, mock
}

// TearDownMockDB closes the mock database connection
func TearDownMockDB(t *testing.T, db *sql.DB) {
	if err := db.Close(); err != nil {
		t.Errorf("Failed to close mock database: %v", err)
	}
}
