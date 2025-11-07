package models

import (
	"database/sql"
	"testing"
	"time"

	"github.com/DATA-DOG/go-sqlmock"
	"github.com/stretchr/testify/assert"
)

// ==================== GetAllPersons Tests ====================

func TestGetAllPersons_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	now := time.Now()
	birthday := time.Date(1950, 1, 1, 0, 0, 0, 0, time.UTC)
	kana := "ヤマダタロウ"
	roomID := "room-1"
	memo := "Test memo"

	rows := sqlmock.NewRows([]string{
		"id", "name", "kana", "birthday", "gender", "room_id", "memo", "created_at", "updated_at",
	}).
		AddRow("person-1", "山田太郎", &kana, &birthday, "male", &roomID, &memo, now, now).
		AddRow("person-2", "佐藤花子", nil, nil, "female", nil, nil, now, now)

	mock.ExpectQuery("SELECT (.+) FROM persons ORDER BY name").
		WillReturnRows(rows)

	// Execute
	persons, err := GetAllPersons(db)

	// Assert
	assert.NoError(t, err)
	assert.Len(t, persons, 2)
	assert.Equal(t, "person-1", persons[0].ID)
	assert.Equal(t, "山田太郎", persons[0].Name)
	assert.Equal(t, "male", persons[0].Gender)
	assert.NotNil(t, persons[0].Kana)
	assert.Equal(t, kana, *persons[0].Kana)
	assert.Equal(t, "person-2", persons[1].ID)
	assert.Equal(t, "佐藤花子", persons[1].Name)
	assert.Equal(t, "female", persons[1].Gender)
	assert.Nil(t, persons[1].Kana)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetAllPersons_EmptyResult(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	rows := sqlmock.NewRows([]string{
		"id", "name", "kana", "birthday", "gender", "room_id", "memo", "created_at", "updated_at",
	})

	mock.ExpectQuery("SELECT (.+) FROM persons ORDER BY name").
		WillReturnRows(rows)

	// Execute
	persons, err := GetAllPersons(db)

	// Assert
	assert.NoError(t, err)
	assert.Empty(t, persons)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetAllPersons_DatabaseError(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	mock.ExpectQuery("SELECT (.+) FROM persons ORDER BY name").
		WillReturnError(sql.ErrConnDone)

	// Execute
	persons, err := GetAllPersons(db)

	// Assert
	assert.Error(t, err)
	assert.Nil(t, persons)
	assert.Equal(t, sql.ErrConnDone, err)
	assert.NoError(t, mock.ExpectationsWereMet())
}

// ==================== GetPersonByID Tests ====================

func TestGetPersonByID_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	personID := "person-1"
	now := time.Now()
	birthday := time.Date(1950, 1, 1, 0, 0, 0, 0, time.UTC)
	kana := "ヤマダタロウ"
	roomID := "room-1"
	memo := "Test memo"

	rows := sqlmock.NewRows([]string{
		"id", "name", "kana", "birthday", "gender", "room_id", "memo", "created_at", "updated_at",
	}).
		AddRow(personID, "山田太郎", &kana, &birthday, "male", &roomID, &memo, now, now)

	mock.ExpectQuery("SELECT (.+) FROM persons WHERE id = (.+)").
		WithArgs(personID).
		WillReturnRows(rows)

	// Execute
	person, err := GetPersonByID(db, personID)

	// Assert
	assert.NoError(t, err)
	assert.NotNil(t, person)
	assert.Equal(t, personID, person.ID)
	assert.Equal(t, "山田太郎", person.Name)
	assert.Equal(t, "male", person.Gender)
	assert.NotNil(t, person.Kana)
	assert.Equal(t, kana, *person.Kana)
	assert.NotNil(t, person.Birthday)
	assert.NotNil(t, person.RoomID)
	assert.Equal(t, roomID, *person.RoomID)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetPersonByID_WithAllFields(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	personID := "person-1"
	now := time.Now()
	birthday := time.Date(1950, 1, 1, 0, 0, 0, 0, time.UTC)
	kana := "ヤマダタロウ"
	roomID := "room-1"
	memo := "詳細なメモ"

	rows := sqlmock.NewRows([]string{
		"id", "name", "kana", "birthday", "gender", "room_id", "memo", "created_at", "updated_at",
	}).
		AddRow(personID, "山田太郎", &kana, &birthday, "male", &roomID, &memo, now, now)

	mock.ExpectQuery("SELECT (.+) FROM persons WHERE id = (.+)").
		WithArgs(personID).
		WillReturnRows(rows)

	// Execute
	person, err := GetPersonByID(db, personID)

	// Assert
	assert.NoError(t, err)
	assert.NotNil(t, person)
	assert.NotNil(t, person.Memo)
	assert.Equal(t, memo, *person.Memo)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetPersonByID_NotFound(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	personID := "non-existent-id"

	mock.ExpectQuery("SELECT (.+) FROM persons WHERE id = (.+)").
		WithArgs(personID).
		WillReturnError(sql.ErrNoRows)

	// Execute
	person, err := GetPersonByID(db, personID)

	// Assert
	assert.NoError(t, err)
	assert.Nil(t, person)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestGetPersonByID_DatabaseError(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	personID := "person-1"

	mock.ExpectQuery("SELECT (.+) FROM persons WHERE id = (.+)").
		WithArgs(personID).
		WillReturnError(sql.ErrConnDone)

	// Execute
	person, err := GetPersonByID(db, personID)

	// Assert
	assert.Error(t, err)
	assert.Nil(t, person)
	assert.Equal(t, sql.ErrConnDone, err)
	assert.NoError(t, mock.ExpectationsWereMet())
}

// ==================== CreatePerson Tests ====================

func TestCreatePerson_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	gender := "male"
	input := PersonCreate{
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

	// Execute
	person, err := CreatePerson(db, input)

	// Assert
	assert.NoError(t, err)
	assert.NotNil(t, person)
	assert.Equal(t, "new-person-id", person.ID)
	assert.Equal(t, "山田太郎", person.Name)
	assert.Equal(t, "male", person.Gender)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestCreatePerson_WithAllFields(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	gender := "female"
	kana := "サトウハナコ"
	birthday := time.Date(1960, 5, 15, 0, 0, 0, 0, time.UTC)
	roomID := "room-101"
	memo := "特記事項"

	input := PersonCreate{
		Name:     "佐藤花子",
		Kana:     &kana,
		Birthday: &birthday,
		Gender:   &gender,
		RoomID:   &roomID,
		Memo:     &memo,
	}

	now := time.Now()

	rows := sqlmock.NewRows([]string{
		"id", "name", "kana", "birthday", "gender", "room_id", "memo", "created_at", "updated_at",
	}).
		AddRow("new-person-id", input.Name, input.Kana, input.Birthday, gender, input.RoomID, input.Memo, now, now)

	mock.ExpectQuery("INSERT INTO persons (.+) RETURNING (.+)").
		WithArgs(input.Name, input.Kana, input.Birthday, gender, input.RoomID, input.Memo).
		WillReturnRows(rows)

	// Execute
	person, err := CreatePerson(db, input)

	// Assert
	assert.NoError(t, err)
	assert.NotNil(t, person)
	assert.Equal(t, "佐藤花子", person.Name)
	assert.NotNil(t, person.Kana)
	assert.Equal(t, kana, *person.Kana)
	assert.NotNil(t, person.Birthday)
	assert.Equal(t, "female", person.Gender)
	assert.NotNil(t, person.RoomID)
	assert.Equal(t, roomID, *person.RoomID)
	assert.NotNil(t, person.Memo)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestCreatePerson_MinimalFields(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	input := PersonCreate{
		Name: "田中次郎",
	}

	now := time.Now()

	rows := sqlmock.NewRows([]string{
		"id", "name", "kana", "birthday", "gender", "room_id", "memo", "created_at", "updated_at",
	}).
		AddRow("new-person-id", input.Name, nil, nil, "unknown", nil, nil, now, now)

	mock.ExpectQuery("INSERT INTO persons (.+) RETURNING (.+)").
		WithArgs(input.Name, input.Kana, input.Birthday, "unknown", input.RoomID, input.Memo).
		WillReturnRows(rows)

	// Execute
	person, err := CreatePerson(db, input)

	// Assert
	assert.NoError(t, err)
	assert.NotNil(t, person)
	assert.Equal(t, "田中次郎", person.Name)
	assert.Equal(t, "unknown", person.Gender)
	assert.Nil(t, person.Kana)
	assert.Nil(t, person.Birthday)
	assert.Nil(t, person.RoomID)
	assert.Nil(t, person.Memo)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestCreatePerson_DatabaseError(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	input := PersonCreate{
		Name: "山田太郎",
	}

	mock.ExpectQuery("INSERT INTO persons (.+) RETURNING (.+)").
		WithArgs(input.Name, input.Kana, input.Birthday, "unknown", input.RoomID, input.Memo).
		WillReturnError(sql.ErrConnDone)

	// Execute
	person, err := CreatePerson(db, input)

	// Assert
	assert.Error(t, err)
	assert.Nil(t, person)
	assert.Equal(t, sql.ErrConnDone, err)
	assert.NoError(t, mock.ExpectationsWereMet())
}

// ==================== UpdatePerson Tests ====================

func TestUpdatePerson_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	personID := "person-1"
	name := "山田太郎（更新）"
	gender := "male"

	input := PersonUpdate{
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

	// Execute
	person, err := UpdatePerson(db, personID, input)

	// Assert
	assert.NoError(t, err)
	assert.NotNil(t, person)
	assert.Equal(t, personID, person.ID)
	assert.Equal(t, name, person.Name)
	assert.Equal(t, gender, person.Gender)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestUpdatePerson_PartialUpdate(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	personID := "person-1"
	memo := "更新されたメモ"

	input := PersonUpdate{
		Memo: &memo,
	}

	now := time.Now()

	rows := sqlmock.NewRows([]string{
		"id", "name", "kana", "birthday", "gender", "room_id", "memo", "created_at", "updated_at",
	}).
		AddRow(personID, "山田太郎", nil, nil, "male", nil, &memo, now, now)

	mock.ExpectQuery("UPDATE persons SET (.+) WHERE id = (.+) RETURNING (.+)").
		WithArgs(memo, personID).
		WillReturnRows(rows)

	// Execute
	person, err := UpdatePerson(db, personID, input)

	// Assert
	assert.NoError(t, err)
	assert.NotNil(t, person)
	assert.NotNil(t, person.Memo)
	assert.Equal(t, memo, *person.Memo)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestUpdatePerson_NoFieldsToUpdate(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	personID := "person-1"
	input := PersonUpdate{}

	now := time.Now()

	// When no fields to update, GetPersonByID is called
	rows := sqlmock.NewRows([]string{
		"id", "name", "kana", "birthday", "gender", "room_id", "memo", "created_at", "updated_at",
	}).
		AddRow(personID, "山田太郎", nil, nil, "male", nil, nil, now, now)

	mock.ExpectQuery("SELECT (.+) FROM persons WHERE id = (.+)").
		WithArgs(personID).
		WillReturnRows(rows)

	// Execute
	person, err := UpdatePerson(db, personID, input)

	// Assert
	assert.NoError(t, err)
	assert.NotNil(t, person)
	assert.Equal(t, personID, person.ID)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestUpdatePerson_NotFound(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	personID := "non-existent-id"
	name := "Test"

	input := PersonUpdate{
		Name: &name,
	}

	mock.ExpectQuery("UPDATE persons SET (.+) WHERE id = (.+) RETURNING (.+)").
		WithArgs(name, personID).
		WillReturnError(sql.ErrNoRows)

	// Execute
	person, err := UpdatePerson(db, personID, input)

	// Assert
	assert.NoError(t, err)
	assert.Nil(t, person)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestUpdatePerson_InvalidData(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	personID := "person-1"
	name := "Test"

	input := PersonUpdate{
		Name: &name,
	}

	mock.ExpectQuery("UPDATE persons SET (.+) WHERE id = (.+) RETURNING (.+)").
		WithArgs(name, personID).
		WillReturnError(sql.ErrConnDone)

	// Execute
	person, err := UpdatePerson(db, personID, input)

	// Assert
	assert.Error(t, err)
	assert.Nil(t, person)
	assert.Equal(t, sql.ErrConnDone, err)
	assert.NoError(t, mock.ExpectationsWereMet())
}

// ==================== DeletePerson Tests ====================

func TestDeletePerson_Success(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	personID := "person-1"

	mock.ExpectExec("DELETE FROM persons WHERE id = (.+)").
		WithArgs(personID).
		WillReturnResult(sqlmock.NewResult(0, 1))

	// Execute
	err = DeletePerson(db, personID)

	// Assert
	assert.NoError(t, err)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestDeletePerson_NotFound(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	personID := "non-existent-id"

	mock.ExpectExec("DELETE FROM persons WHERE id = (.+)").
		WithArgs(personID).
		WillReturnResult(sqlmock.NewResult(0, 0))

	// Execute
	err = DeletePerson(db, personID)

	// Assert
	assert.Error(t, err)
	assert.Equal(t, sql.ErrNoRows, err)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestDeletePerson_DatabaseError(t *testing.T) {
	db, mock, err := sqlmock.New()
	assert.NoError(t, err)
	defer db.Close()

	personID := "person-1"

	mock.ExpectExec("DELETE FROM persons WHERE id = (.+)").
		WithArgs(personID).
		WillReturnError(sql.ErrConnDone)

	// Execute
	err = DeletePerson(db, personID)

	// Assert
	assert.Error(t, err)
	assert.Equal(t, sql.ErrConnDone, err)
	assert.NoError(t, mock.ExpectationsWereMet())
}
