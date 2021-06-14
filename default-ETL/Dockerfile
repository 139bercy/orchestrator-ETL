# This relies on the image coming from the pypel repository
# If this image doesn't exist locally, you need to build it from
# the pypel submodule!
# The instructions can be found in modules/pypel/README.md
#
# Otherwise, from the root directory of the project, you can do:
# docker build -f ./modules/pypel/docker/Dockerfile -t pypel:dev ./modules/pypel/
#
# Please note that this process is automated through the scripts/start.sh
FROM pypel:dev

WORKDIR /app

# Define entrypoint
COPY docker-entrypoint.sh /app/docker-entrypoint.sh
ENTRYPOINT [ "bash", "/app/docker-entrypoint.sh"]
# Please note that this script expects a conf folder with the relevant files in /app
# For more details, have a look at https://github.com/139bercy/data-project-template/ETL/src/main.py

# Add the requirements from project
# COPY requirements.txt /app/
# && pip install --no-cache-dir -r requirements.txt \
# RUN apt-get update && apt-get install build-essential jq -y --no-install-recommends \
# && apt-get remove build-essential -y \
RUN apt-get update && apt-get install jq -y --no-install-recommends \
  && apt-get clean && rm -rf /var/cache/apt/*
#
# COPY setup.py /app/setup.py

RUN mkdir -p /app/logging

# COPY src /app/src
COPY conf /app/conf

VOLUME /data
