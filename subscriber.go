package bucketSubscriber

import (
	"context"
	"database/sql"
	"fmt"
	"log"
	"os"

	// pq for postgres
	_ "github.com/lib/pq"
)

// GCSEvent ...
type GCSEvent struct {
	Kind   string `json:"kind"`
	ID     string `json:"id"`
	Name   string `json:"name"`
	Bucket string `json:"bucket"`
}

var (
	db              *sql.DB
	insertStatement = `INSERT INTO events (id, name, kind, bucket)
										 VALUES ($1, $2, $3, $4)`
	connectionName = mustGetenv("CLOUDSQL_CONNECTION_NAME")
	dbUser         = mustGetenv("CLOUDSQL_USER")
	dbPassword     = mustGetenv("CLOUDSQL_PASSWORD")
	dbName         = mustGetenv("CLOUDSQL_DB_NAME")
	dsn            = fmt.Sprintf("user=%s password=%s dbname=%s host=/cloudsql/%s sslmode=disable", dbUser, dbPassword, dbName, connectionName)
)

func init() {
	var err error
	db, err = sql.Open("postgres", dsn)
	if err != nil {
		panic(err)
	}
}

// Handler ...
func Handler(ctx context.Context, e GCSEvent) error {
	_, err := db.Exec(insertStatement, e.ID, e.Name, e.Kind, e.Bucket)
	if err != nil {
		return err
	}
	return nil
}

func mustGetenv(k string) string {
	v := os.Getenv(k)
	if v == "" {
		log.Panicf("%s environment variable not set.", k)
	}
	return v
}
