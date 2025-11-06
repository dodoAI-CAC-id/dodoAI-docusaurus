package models

import (
	"database/sql"
	"testing"
	"time"

	"github.com/DATA-DOG/go-sqlmock"
	"github.com/stretchr/testify/assert"
)

// ==================== GetAllStaffs Tests ====================

func TestGetAllStaffs_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	now := time.Now()
	deptID1 := "dept-1"
	deptName1 := "看護部"
	deptID2 := "dept-2"
	deptName2 := "介護部"

	rows := sqlmock.NewRows([]string{
		"id", "name", "department_id", "department_name", "role", "created_at", "updated_at",
	}).
		AddRow("staff-1", "山田太郎", &deptID1, &deptName1, "nurse", now, now).
		AddRow("staff-2", "佐藤花子", &deptID2, &deptName2, "caregiver", now, now).
		AddRow("staff-3", "田中次郎", nil, nil, "admin", now, now)

	mock.ExpectQuery("SELECT (.+) FROM staffs s LEFT JOIN departments d (.+) ORDER BY s.name").
		WillReturnRows(rows)

	// Execute
	staffs, err := GetAllStaffs(db)

	// Assert
	assert.NoError(t, err)
	assert.Len(t, staffs, 3)
	assert.Equal(t, "staff-1", staffs[0].ID)
	assert.Equal(t, "山田太郎", staffs[0].Name)
	assert.Equal(t, "nurse", staffs[0].Role)
	assert.NotNil(t, staffs[0].DepartmentID)
	assert.Equal(t, deptID1, *staffs[0].DepartmentID)
	assert.NotNil(t, staffs[0].DepartmentName)
	assert.Equal(t, deptName1, *staffs[0].DepartmentName)

	assert.Equal(t, "staff-3", staffs[2].ID)
	assert.Equal(t, "admin", staffs[2].Role)
	assert.Nil(t, staffs[2].DepartmentID)
	assert.Nil(t, staffs[2].DepartmentName)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetAllStaffs_EmptyResult(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	rows := sqlmock.NewRows([]string{
		"id", "name", "department_id", "department_name", "role", "created_at", "updated_at",
	})

	mock.ExpectQuery("SELECT (.+) FROM staffs s LEFT JOIN departments d (.+) ORDER BY s.name").
		WillReturnRows(rows)

	// Execute
	staffs, err := GetAllStaffs(db)

	// Assert
	assert.NoError(t, err)
	assert.Empty(t, staffs)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetAllStaffs_DatabaseError(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	mock.ExpectQuery("SELECT (.+) FROM staffs s LEFT JOIN departments d (.+) ORDER BY s.name").
		WillReturnError(sql.ErrConnDone)

	// Execute
	staffs, err := GetAllStaffs(db)

	// Assert
	assert.Error(t, err)
	assert.Nil(t, staffs)
	assert.Equal(t, sql.ErrConnDone, err)
	assert.NoError(t, mock.ExpectationsWereMet())
}

// ==================== GetStaffByID Tests ====================

func TestGetStaffByID_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	staffID := "staff-1"
	now := time.Now()
	deptID := "dept-1"
	deptName := "看護部"

	rows := sqlmock.NewRows([]string{
		"id", "name", "department_id", "department_name", "role", "created_at", "updated_at",
	}).
		AddRow(staffID, "山田太郎", &deptID, &deptName, "nurse", now, now)

	mock.ExpectQuery("SELECT (.+) FROM staffs s LEFT JOIN departments d (.+) WHERE s.id = (.+)").
		WithArgs(staffID).
		WillReturnRows(rows)

	// Execute
	staff, err := GetStaffByID(db, staffID)

	// Assert
	assert.NoError(t, err)
	assert.NotNil(t, staff)
	assert.Equal(t, staffID, staff.ID)
	assert.Equal(t, "山田太郎", staff.Name)
	assert.Equal(t, "nurse", staff.Role)
	assert.NotNil(t, staff.DepartmentID)
	assert.Equal(t, deptID, *staff.DepartmentID)
	assert.NotNil(t, staff.DepartmentName)
	assert.Equal(t, deptName, *staff.DepartmentName)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetStaffByID_WithoutDepartment(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	staffID := "staff-1"
	now := time.Now()

	rows := sqlmock.NewRows([]string{
		"id", "name", "department_id", "department_name", "role", "created_at", "updated_at",
	}).
		AddRow(staffID, "田中次郎", nil, nil, "admin", now, now)

	mock.ExpectQuery("SELECT (.+) FROM staffs s LEFT JOIN departments d (.+) WHERE s.id = (.+)").
		WithArgs(staffID).
		WillReturnRows(rows)

	// Execute
	staff, err := GetStaffByID(db, staffID)

	// Assert
	assert.NoError(t, err)
	assert.NotNil(t, staff)
	assert.Equal(t, staffID, staff.ID)
	assert.Equal(t, "admin", staff.Role)
	assert.Nil(t, staff.DepartmentID)
	assert.Nil(t, staff.DepartmentName)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetStaffByID_NotFound(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	staffID := "non-existent-id"

	mock.ExpectQuery("SELECT (.+) FROM staffs s LEFT JOIN departments d (.+) WHERE s.id = (.+)").
		WithArgs(staffID).
		WillReturnError(sql.ErrNoRows)

	// Execute
	staff, err := GetStaffByID(db, staffID)

	// Assert
	assert.NoError(t, err)
	assert.Nil(t, staff)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetStaffByID_DatabaseError(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	staffID := "staff-1"

	mock.ExpectQuery("SELECT (.+) FROM staffs s LEFT JOIN departments d (.+) WHERE s.id = (.+)").
		WithArgs(staffID).
		WillReturnError(sql.ErrConnDone)

	// Execute
	staff, err := GetStaffByID(db, staffID)

	// Assert
	assert.Error(t, err)
	assert.Nil(t, staff)
	assert.Equal(t, sql.ErrConnDone, err)
	assert.NoError(t, mock.ExpectationsWereMet())
}

// ==================== GetAllDepartments Tests ====================

func TestGetAllDepartments_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	now := time.Now()

	rows := sqlmock.NewRows([]string{
		"id", "name", "created_at", "updated_at",
	}).
		AddRow("dept-1", "看護部", now, now).
		AddRow("dept-2", "介護部", now, now).
		AddRow("dept-3", "管理部", now, now)

	mock.ExpectQuery("SELECT (.+) FROM departments ORDER BY name").
		WillReturnRows(rows)

	// Execute
	departments, err := GetAllDepartments(db)

	// Assert
	assert.NoError(t, err)
	assert.Len(t, departments, 3)
	assert.Equal(t, "dept-1", departments[0].ID)
	assert.Equal(t, "看護部", departments[0].Name)
	assert.Equal(t, "dept-2", departments[1].ID)
	assert.Equal(t, "介護部", departments[1].Name)
	assert.Equal(t, "dept-3", departments[2].ID)
	assert.Equal(t, "管理部", departments[2].Name)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetAllDepartments_EmptyResult(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	rows := sqlmock.NewRows([]string{
		"id", "name", "created_at", "updated_at",
	})

	mock.ExpectQuery("SELECT (.+) FROM departments ORDER BY name").
		WillReturnRows(rows)

	// Execute
	departments, err := GetAllDepartments(db)

	// Assert
	assert.NoError(t, err)
	assert.Empty(t, departments)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetAllDepartments_DatabaseError(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	mock.ExpectQuery("SELECT (.+) FROM departments ORDER BY name").
		WillReturnError(sql.ErrConnDone)

	// Execute
	departments, err := GetAllDepartments(db)

	// Assert
	assert.Error(t, err)
	assert.Nil(t, departments)
	assert.Equal(t, sql.ErrConnDone, err)
	assert.NoError(t, mock.ExpectationsWereMet())
}
