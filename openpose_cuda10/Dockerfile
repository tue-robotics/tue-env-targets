FROM cucrrobotics/cucr-env-cuda:master

# Build time arguments and their default values
ARG CI=false
ARG BRANCH=master
ARG PULL_REQUEST=false
ARG COMMIT=

# Update the image and install basic packages
RUN sudo apt-get update -qq && \
    # Set the CI args in the container as docker currently provides no method to
    # remove the environment variables
    # NOTE: The following exports will exist only in this container
    export CI=$CI && \
    export BRANCH=$BRANCH && \
    export PULL_REQUEST=$PULL_REQUEST && \
    export COMMIT=$COMMIT && \
    # Make cucr-env available to the intermediate image
    # This step needs to be executed at every RUN step
    source ~/.bashrc && \
    # Install ros-image_recognition_openpose target
    cucr-get install ros-image_recognition_openpose --branch="$BRANCH" && \
    # Make workspace
    cucr-make && \
    source ~/.bashrc && \
    # Install openpose
    cucr-get install openpose_cuda10
