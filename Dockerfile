FROM docker.elastic.co/logstash/logstash:5.3.2
COPY logstash-filter-throttle-prop-0.0.0.gem /usr/share/logstash/plugin/logstash-filter-throttle-prop/logstash-filter-throttle-prop-0.0.0.gem
RUN logstash-plugin install /usr/share/logstash/plugin/logstash-filter-throttle-prop/logstash-filter-throttle-prop-0.0.0.gem
