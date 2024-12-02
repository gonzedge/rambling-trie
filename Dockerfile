FROM ruby:3.3.6

RUN bundle config --global frozen 1

WORKDIR /usr/rambling-trie
RUN git init

# Copy strictly what is necessary to install dependencies
COPY Gemfile Gemfile.lock rambling-trie.gemspec ./
COPY lib ./lib

# Install dependencies
RUN bundle install

# Copy rest of Ruby and Markdown files
COPY Rakefile ./
COPY *.md ./
COPY assets ./assets
COPY sig ./sig
COPY spec ./spec
COPY tasks ./tasks
COPY scripts ./scripts

# Copy rest of configuration files
COPY *file ./
COPY *.yml ./
COPY .mdl* ./
COPY .yardopts ./
