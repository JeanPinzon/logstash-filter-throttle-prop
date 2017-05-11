FROM docker.elastic.co/logstash/logstash:5.2.0
RUN logstash-plugin install logstash-filter-throttle-prop
