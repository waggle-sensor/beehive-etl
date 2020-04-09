FROM python:3

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

COPY ssh-config /root/.ssh/config

CMD [ "bash", "./update-digests.sh" ]
