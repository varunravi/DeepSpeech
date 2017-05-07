# Project DeepSpeech [![Documentation Status](https://readthedocs.org/projects/deepspeech/badge/?version=latest)](http://deepspeech.readthedocs.io/en/latest/?badge=latest)

Project DeepSpeech is an open source Speech-To-Text engine that uses a model trained by machine learning techniques, based on [Baidu's Deep Speech research paper](https://arxiv.org/abs/1412.5567). Project DeepSpeech uses Google's [TensorFlow](https://www.tensorflow.org/) project to facilitate implementation.

**Table of Contents**

- [Prerequisites](#prerequisites)
- [Install](#install)
- [Recommendations](#recommendations)
- [Training a model](#training-a-model)
- [Checkpointing](#checkpointing)
- [Exporting a model for serving](#exporting-a-model-for-serving)
- [Distributed computing across more than one machine](#distributed-computing-across-more-than-one-machine)
- [Documentation](#documentation)
- [Contact/Getting Help](#contactgetting-help)

## Prerequisites

* [Git Large File Storage](https://git-lfs.github.com/)
* [TensorFlow 1.0 or above](https://www.tensorflow.org/install/)
* [SciPy](https://scipy.org/install.html)
* [PyXDG](https://pypi.python.org/pypi/pyxdg)
* [python_speech_features](https://pypi.python.org/pypi/python_speech_features)
* [python sox](https://pypi.python.org/pypi/sox)


## Install

Manually install [Git Large File Storage](https://git-lfs.github.com/), then open a terminal and run:
```bash
git clone https://github.com/mozilla/DeepSpeech
cd DeepSpeech
pip install -r requirements.txt
```

## Recommendations

If you have a capable (Nvidia, at least 8GB of VRAM) GPU, it is highly recommended to install TensorFlow with GPU support. Training will likely be significantly quicker than using the CPU.

## Training a model

The central (Python) script is `DeepSpeech.py` in the project's root directory. For its list of command line options, you can call:

```bash
$ ./DeepSpeech.py --help
```

To get the output of this in a slightly better formatted way, you can also look up the option definitions top of `DeepSpeech.py`.
For executing pre-configured training scenarios, there is a collection of convenience scripts in the `bin` folder. Most of them are named after the corpora they are configured for. Keep in mind that the other speech corpora are *very large*, on the order of tens of gigabytes, and some aren't free. Downloading and preprocessing them can take a very long time, and training on them without a fast GPU (GTX 10 series recommended) takes even longer. If you experience GPU OOM errors while training, try reducing `batch_size`.

As a simple first example you can open a terminal, change to the directory of the DeepSpeech checkout and run:

```bash
$ ./bin/run-ldc93s1.sh
```

This script will train on a small sample dataset called LDC93S1, which can be overfitted on a GPU in a few minutes for demonstration purposes. From here, you can alter any variables with regards to what dataset is used, how many training iterations are run and the default values of the network parameters.
Feel also free to pass additional (or overriding) `DeepSpeech.py` parameters to these scripts.
Then, just run the script to train the modified network.

## Checkpointing

During training of a model so called checkpoints will get stored on disk. This takes place at a configurable time interval. The purpose of checkpoints is to allow interruption (also in case of some unexpected failure) and later continuation of training without loosing hours of training time. Resuming from checkpoints happens automatically by just (re)starting training with the same `--checkpoint_dir` of the former run.

Be aware however that checkpoints are only valid for the same model geometry they had been generated from. In other words: If there are error messages of certain `Tensors` having incompatible dimensions, this is most likely due to an incompatible model change. One usual way out would be to wipe all checkpoint files in the checkpoint directory or changing it before starting the training.

## Exporting a model for serving

If the `--export_dir` parameter is provided, a model will have been exported to this directory during training.
Refer to the corresponding [README.md](native_client/README.md) for information on building and running a client that can use the exported model.

## Distributed computing across more than one machine

DeepSpeech has built-in support for [distributed TensorFlow](https://www.tensorflow.org/deploy/distributed). To get an idea on how this works, you can use the script `bin/run-cluster.sh` for running a cluster with workers just on the local machine.

```bash
$ bin/run-cluster.sh --help
Usage: run-cluster.sh [--help] [--script script] [p:w:g] <arg>*

--help      print this help message
--script    run the provided script instead of DeepSpeech.py
p           number of local parameter servers
w           number of local workers
g           number of local GPUs per worker
<arg>*      remaining parameters will be forwarded to DeepSpeech.py or a provided script

Example usage - The following example will create a local DeepSpeech.py cluster
with 1 parameter server, and 2 workers with 1 GPU each:
$ run-cluster.sh 1:2:1 --epoch 10
```

Be aware that for the help example to be able to run, you need at least two `CUDA` capable GPUs (2 workers times 1 GPU). The script utilizes environment variable `CUDA_VISIBLE_DEVICES` for `DeepSpeech.py` to see only the provided number of GPUs per worker.
The script is meant to be a template for your own distributed computing instrumentation. Just modify the startup code for the different servers (workers and parameter servers) accordingly. You could use SSH or something similar for running them on your remote hosts.

## Documentation

Documentation (incomplete) for the project can be found here: http://deepspeech.readthedocs.io/en/latest/

## Contact/Getting Help

First, check out our existing issues and the [FAQ on the wiki](https://github.com/mozilla/DeepSpeech/wiki) to see if your question is answered there. If it's not, and the question is about the code or the project's goals, feel free to open an issue in the repo. If the question is better suited for the FAQ, the team hangs out in the #machinelearning channel on [Mozilla IRC](https://wiki.mozilla.org/IRC), and people there can try to answer/help.
