FROM meltano/meltano:latest-python3.12

WORKDIR /project

RUN apt update && \
    apt install -y jq curl inetutils-ping && \
    apt clean

# Install any additional requirements
COPY ./requirements.txt .
RUN pip install -r requirements.txt

# Copy over Meltano project directory
COPY . .
RUN meltano install

# Prevent runtime modifications
ENV MELTANO_PROJECT_READONLY=1

ENTRYPOINT ["meltano"]
CMD ["run", "tap-rest-api-msdk", "target-postgres"]
