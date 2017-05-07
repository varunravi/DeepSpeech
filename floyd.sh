#LDC93S1.txt  LDC93S1.wav  __init__.py  ldc93s1.csv
TRAIN_DATA="./data/ldc93s1/ldc93s1.csv"
DEV_DATA="./data/ldc93s1/ldc93s1.csv"
TEST_DATA="./data/ldc93s1/ldc93s1.csv"
checkpoint_dir="./checkpoint"

floyd run --gpu "python setup.py build && python setup.py install && python DeepSpeech.py" --env "tensorflow-1.0:py2"
#  --train_files $TRAIN_DATA \
#  --dev_files $DEV_DATA \
#  --test_files $TEST_DATA \
# --train_batch_size 1  \
#  --dev_batch_size 1 \
#  --test_batch_size 1 \
#  --n_hidden 494 \
#  --epoch 50 \
#  --checkpoint_dir "$checkpoint_dir"'''

