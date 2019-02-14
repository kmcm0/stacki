#!/bin/bash
#
# @copyright@
# @copyright@

cat > redis.yaml <<EOF
redis:
  password: ${REDIS_PASSWORD}
EOF

j2 -o /etc/redis.conf redis.conf.j2 redis.yaml

/usr/bin/redis-server /etc/redis.conf
