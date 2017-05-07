TRAIN_DATA="./data/ldc93s2/ldc93s2.csv"
DEV_DATA="./data/ldc93s2/ldc93s2.csv"
TEST_DATA="./data/ldc93s2/ldc93s2.csv"
checkpoint_dir="./checkpoint"
now=$(date +"%Y%m%d_%H%M%S")
JOB_NAME="job_$now"

gcloud ml-engine jobs submit training $JOB_NAME \
--module-name trainer.task \
--package-path trainer/ \
--job-dir gs://deep_speech1/output \
--region us-central1 \
-- \
--train_files $TRAIN_DATA \
--dev_files $DEV_DATA \
--test_files $TEST_DATA \
--train_batch_size 1  \
--dev_batch_size 1 \
--test_batch_size 1 \
--n_hidden 494 \
--epoch 50 \
--checkpoint_dir "$checkpoint_dir" \
