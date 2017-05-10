FROM docker.elastic.co/logstash/logstash:5.3.2
RUN logstash-plugin install logstash-filter-throttle-prop
