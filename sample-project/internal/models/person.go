package models

import (
	"database/sql"
	"time"
)

// Person represents a monitored person
type Person struct {
	ID        string     `json:"id"`
	Name      string     `json:"name"`
	Kana      *string    `json:"kana,omitempty"`
	Birthday  *time.Time `json:"birthday,omitempty"`
	Gender    string     `json:"gender"`
	RoomID    *string    `json:"roomId,omitempty"`
	Memo      *string    `json:"memo,omitempty"`
	CreatedAt time.Time  `json:"createdAt"`
	UpdatedAt time.Time  `json:"updatedAt"`
}

// PersonCreate represents the input for creating a person
type PersonCreate struct {
	Name     string     `json:"name"`
	Kana     *string    `json:"kana,omitempty"`
	Birthday *time.Time `json:"birthday,omitempty"`
	Gender   *string    `json:"gender,omitempty"`
	RoomID   *string    `json:"roomId,omitempty"`
	Memo     *string    `json:"memo,omitempty"`
}

// PersonUpdate represents the input for updating a person
type PersonUpdate struct {
	Name     *string    `json:"name,omitempty"`
	Kana     *string    `json:"kana,omitempty"`
	Birthday *time.Time `json:"birthday,omitempty"`
	Gender   *string    `json:"gender,omitempty"`
	RoomID   *string    `json:"roomId,omitempty"`
	Memo     *string    `json:"memo,omitempty"`
}

// GetAllPersons retrieves all persons
func GetAllPersons(db *sql.DB) ([]Person, error) {
	query := `
		SELECT id, name, kana, birthday, gender, room_id, memo, created_at, updated_at
		FROM persons
		ORDER BY name
	`

	rows, err := db.Query(query)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	persons := make([]Person, 0)
	for rows.Next() {
		var person Person
		err := rows.Scan(
			&person.ID,
			&person.Name,
			&person.Kana,
			&person.Birthday,
			&person.Gender,
			&person.RoomID,
			&person.Memo,
			&person.CreatedAt,
			&person.UpdatedAt,
		)
		if err != nil {
			return nil, err
		}
		persons = append(persons, person)
	}

	return persons, rows.Err()
}

// GetPersonByID retrieves a specific person by ID
func GetPersonByID(db *sql.DB, id string) (*Person, error) {
	query := `
		SELECT id, name, kana, birthday, gender, room_id, memo, created_at, updated_at
		FROM persons
		WHERE id = $1
	`

	var person Person
	err := db.QueryRow(query, id).Scan(
		&person.ID,
		&person.Name,
		&person.Kana,
		&person.Birthday,
		&person.Gender,
		&person.RoomID,
		&person.Memo,
		&person.CreatedAt,
		&person.UpdatedAt,
	)

	if err == sql.ErrNoRows {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}

	return &person, nil
}

// CreatePerson creates a new person
func CreatePerson(db *sql.DB, input PersonCreate) (*Person, error) {
	gender := "unknown"
	if input.Gender != nil {
		gender = *input.Gender
	}

	query := `
		INSERT INTO persons (name, kana, birthday, gender, room_id, memo)
		VALUES ($1, $2, $3, $4, $5, $6)
		RETURNING id, name, kana, birthday, gender, room_id, memo, created_at, updated_at
	`

	var person Person
	err := db.QueryRow(
		query,
		input.Name,
		input.Kana,
		input.Birthday,
		gender,
		input.RoomID,
		input.Memo,
	).Scan(
		&person.ID,
		&person.Name,
		&person.Kana,
		&person.Birthday,
		&person.Gender,
		&person.RoomID,
		&person.Memo,
		&person.CreatedAt,
		&person.UpdatedAt,
	)

	if err != nil {
		return nil, err
	}

	return &person, nil
}

// UpdatePerson updates an existing person
func UpdatePerson(db *sql.DB, id string, input PersonUpdate) (*Person, error) {
	// Build dynamic update query
	updateFields := []string{}
	args := []interface{}{}
	argIdx := 1

	if input.Name != nil {
		updateFields = append(updateFields, "name = $"+string(rune('0'+argIdx)))
		args = append(args, *input.Name)
		argIdx++
	}

	if input.Kana != nil {
		updateFields = append(updateFields, "kana = $"+string(rune('0'+argIdx)))
		args = append(args, *input.Kana)
		argIdx++
	}

	if input.Birthday != nil {
		updateFields = append(updateFields, "birthday = $"+string(rune('0'+argIdx)))
		args = append(args, *input.Birthday)
		argIdx++
	}

	if input.Gender != nil {
		updateFields = append(updateFields, "gender = $"+string(rune('0'+argIdx)))
		args = append(args, *input.Gender)
		argIdx++
	}

	if input.RoomID != nil {
		updateFields = append(updateFields, "room_id = $"+string(rune('0'+argIdx)))
		args = append(args, *input.RoomID)
		argIdx++
	}

	if input.Memo != nil {
		updateFields = append(updateFields, "memo = $"+string(rune('0'+argIdx)))
		args = append(args, *input.Memo)
		argIdx++
	}

	if len(updateFields) == 0 {
		// No fields to update, return current person
		return GetPersonByID(db, id)
	}

	query := `UPDATE persons SET ` + updateFields[0]
	for i := 1; i < len(updateFields); i++ {
		query += ", " + updateFields[i]
	}
	query += `, updated_at = CURRENT_TIMESTAMP
		WHERE id = $` + string(rune('0'+argIdx)) + `
		RETURNING id, name, kana, birthday, gender, room_id, memo, created_at, updated_at
	`
	args = append(args, id)

	var person Person
	err := db.QueryRow(query, args...).Scan(
		&person.ID,
		&person.Name,
		&person.Kana,
		&person.Birthday,
		&person.Gender,
		&person.RoomID,
		&person.Memo,
		&person.CreatedAt,
		&person.UpdatedAt,
	)

	if err == sql.ErrNoRows {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}

	return &person, nil
}

// DeletePerson deletes a person from the database
func DeletePerson(db *sql.DB, id string) error {
	query := `DELETE FROM persons WHERE id = $1`

	result, err := db.Exec(query, id)
	if err != nil {
		return err
	}

	rowsAffected, err := result.RowsAffected()
	if err != nil {
		return err
	}

	if rowsAffected == 0 {
		return sql.ErrNoRows
	}

	return nil
}
