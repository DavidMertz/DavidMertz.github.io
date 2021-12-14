## About the Repository

This repository contains the content used to prepare the talk *An introduction to 
Generative Adversarial Networks with PyTorch*, presented at 
[PiterPy 2019](https://piterpy.com/).

Versions of this material are used by other training provided by David Mertz 
and [KDM Training](http://kdm.training).

## Installing training materials

To run the notebook making up this content, please configure the environments 
you will need.  Within the repository, find the file `requirements.txt`
to install software using `pip`, or the file `environment.yml` to
install software using `conda`.  I.e.:

```bash
$ conda env create -f environment.yml
$ conda activate PiterPy-Mertz
(PiterPy-Mertz) $ jupyter notebook 
```

Or

```bash
$ pip install -r requirements.txt
$ juypter notebook 
```

PyTorch often works vastly faster when utilizing a CUDA GPU to
perform training.  Students who wish to be able to follow along
running the material on their own machines in real time, are advised
to obtain access to a GPU machine while attending this webinar.
 
Numerous cloud services provide access to rented GPU instances are
reasonable hourly costs.  AWS EC2 instances are very well known, and
can be leased with good GPU configurations.  The author is very fond
of a service called vast.ai (https://vast.ai/) that he will use
during presentation of the webinar.   Of course, if you have any
moderately recent CUDA-enabled GPU on your home or work machine, you
will be fine also.

If you run this material on a leased cloud GPU, you will probably
start with a fairly minimal base Docker image.  It will probably be
a good idea to install a few tools using the system installer (some
of those are used in the lessons themselves, but nothing important
depends on them if you follow without those available).

I setup a new cloud instance with these steps, once I open a
terminal into that machine:

```bash
$ git clone https://github.com/DavidMertz/PiterPy-2019.git
$ cd PiterPy-2019/
$ apt-get update  # Make sure latest repo information
$ apt-get install jq curl tree vim -y
$ pip install --upgrade pip  # latest version changes often
$  pip install -r requirements.txt
```

## Recommended reading

* [Beginner Machine Learning with `scikit-learn`](https://github.com/DavidMertz/ML-Live-Beginner).

* [Intermediate Machine Learning with `scikit-learn`](https://github.com/DavidMertz/ML-Live-Intermediate).

* [(Video) Machine Learning with scikit-learn LiveLessons](https://www.oreilly.com/library/view/machine-learning-with/9780135474198/), by David Mertz.

* [(Video) Machine Learning with PyTorch LiveLessons](https://www.oreilly.com/library/view/TODO), by David Mertz.

* _Programming PyTorch for Deep Learning: Creating adn Deploying Deep Learning Applications_, by Ian Pointer.

* _Hands-On Machine Learning with Scikit-Learn and TensorFlow: Concepts, Tools, and Techniques to Build Intelligent Systems_, by Aurélien Géron.

* _Deep Learning with Python_, by Francois Chollet.

* _Introduction to Machine Learning with Python: A Guide for Data Scientists_, by by Andreas C. Müller & Sarah Guido.

* [Documentation of PyTorch](https://pytorch.org/docs/stable/index.html)
