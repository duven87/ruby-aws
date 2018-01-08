FROM ruby:2.5.0-slim-stretch

RUN mkdir -p /ec2
COPY Gemfile /ec2
COPY Gemfile.lock /ec2
WORKDIR /ec2
RUN bundle install
COPY . /ec2
CMD ["ruby","ec2.rb","-h"]
