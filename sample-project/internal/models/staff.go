package models

import (
	"database/sql"
	"time"
)

// Staff represents a staff member
type Staff struct {
	ID             string    `json:"id"`
	Name           string    `json:"name"`
	DepartmentID   *string   `json:"departmentId,omitempty"`
	DepartmentName *string   `json:"departmentName,omitempty"`
	Role           string    `json:"role"`
	CreatedAt      time.Time `json:"createdAt"`
	UpdatedAt      time.Time `json:"updatedAt"`
}

// Department represents a department
type Department struct {
	ID        string    `json:"id"`
	Name      string    `json:"name"`
	CreatedAt time.Time `json:"createdAt"`
	UpdatedAt time.Time `json:"updatedAt"`
}

// GetAllStaffs retrieves all staff members
func GetAllStaffs(db *sql.DB) ([]Staff, error) {
	query := `
		SELECT s.id, s.name, s.department_id, d.name as department_name, s.role, s.created_at, s.updated_at
		FROM staffs s
		LEFT JOIN departments d ON s.department_id = d.id
		ORDER BY s.name
	`

	rows, err := db.Query(query)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	staffs := make([]Staff, 0)
	for rows.Next() {
		var staff Staff
		err := rows.Scan(
			&staff.ID,
			&staff.Name,
			&staff.DepartmentID,
			&staff.DepartmentName,
			&staff.Role,
			&staff.CreatedAt,
			&staff.UpdatedAt,
		)
		if err != nil {
			return nil, err
		}
		staffs = append(staffs, staff)
	}

	return staffs, rows.Err()
}

// GetStaffByID retrieves a specific staff member by ID
func GetStaffByID(db *sql.DB, id string) (*Staff, error) {
	query := `
		SELECT s.id, s.name, s.department_id, d.name as department_name, s.role, s.created_at, s.updated_at
		FROM staffs s
		LEFT JOIN departments d ON s.department_id = d.id
		WHERE s.id = $1
	`

	var staff Staff
	err := db.QueryRow(query, id).Scan(
		&staff.ID,
		&staff.Name,
		&staff.DepartmentID,
		&staff.DepartmentName,
		&staff.Role,
		&staff.CreatedAt,
		&staff.UpdatedAt,
	)

	if err == sql.ErrNoRows {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}

	return &staff, nil
}

// GetAllDepartments retrieves all departments
func GetAllDepartments(db *sql.DB) ([]Department, error) {
	query := `
		SELECT id, name, created_at, updated_at
		FROM departments
		ORDER BY name
	`

	rows, err := db.Query(query)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	departments := make([]Department, 0)
	for rows.Next() {
		var dept Department
		err := rows.Scan(
			&dept.ID,
			&dept.Name,
			&dept.CreatedAt,
			&dept.UpdatedAt,
		)
		if err != nil {
			return nil, err
		}
		departments = append(departments, dept)
	}

	return departments, rows.Err()
}
