package bucketSubscriber

import (
	"context"
	"testing"

	"github.com/google/uuid"
)

func TestSubscriber(t *testing.T) {
	err := Handler(context.TODO(), GCSEvent{
		Name:   "Hats",
		Bucket: "Bucket",
		ID:     uuid.New().String(),
		Kind:   "Kind",
	})
	if err != nil {
		t.Error(err)
	}
}
