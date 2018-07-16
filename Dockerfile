FROM ruby:2.5

# Specify warking directoy
WORKDIR /opt/rails

# Copy project to container
COPY . .

# Set identity file
RUN echo "host" > server_identity

# Setup this environment to development
ENV RAILS_ENV "development"
ENV DEBIAN_FRONTEND noninteractive

# Install dependencies: cmake for gem rugged and nodejs for rails.
# Requires some workaround to remove util `cmdtest` that provides a bin yarn
# and prepare and install yarn...
RUN apt-get update && apt-get install -y apt-transport-https
RUN curl -sS 'https://dl.yarnpkg.com/debian/pubkey.gpg' | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y yarn nodejs cmake

# Install ruby libraries
RUN bundle install

# Install JavaScript libraries
RUN bin/rails yarn:install
RUN bundle exec rake bin/setup

EXPOSE 3000

# Run the development server
CMD ["bin/rails", "server"]
