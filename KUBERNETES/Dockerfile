#FROM node:12
FROM node:12.2.0-alpine

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm init -y

RUN npm install 

COPY .   /usr/src/app

EXPOSE 8080


CMD npm run initdb && npm run dev







#RUN (cd /usr/src/app &&  nohup npm run dev  < /dev/null > /dev/null 2>&1 &)

#RUN nohup npm run dev  < /dev/null > /dev/null 2>&1 &

#RUN node src/index.js

#CMD [ "node", "/usr/src/app/src/index.js" ]

#CMD node src/index.js


#CMD ["npm run dev"]
# ENTRYPOINT ["tail", "-f", "/dev/null"]
# go in a container : sudo docker exec -it fc7e2a4d664c /bin/bash
# docker run -d -p 8080:8080 my tail -f /dev/null

