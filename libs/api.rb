#!/usr/bin/ruby -w
# -*- coding: UTF-8 -*-

# Author: liushuyu

# Copyright © 2017 liushuyu <liushuyu@users.noreply.github.com>
# This work is free. You can redistribute it and/or modify it under the
# terms of the Do What The Fuck You Want To Public License, Version 2,
# as published by Sam Hocevar. See the LICENSE file for more details.
require 'sinatra'
require 'logger'
require 'json'
require_relative './database.rb'

class PAKREQAPI < Sinatra::Base

  def initialize(app=nil)
    @@lists = {}
    @@db = Database.db_open
    if @@db[1] == false
      exit
    end
    super(app)
  end

  set :bind, '0.0.0.0'
  set :root, Proc.new {File.join(File.dirname(__FILE__), "../")}
  set :public_folder, Proc.new { File.join(root, "html") }
  set :static_cache_control, [:public, :max_age => 1800]

  # for diagnosis purpose
  get '/ping' do
    204
  end

  get '/' do
    redirect '/index.html', 301
  end

  # list pending reqs
  get '/api/lists.json' do
    @@lists = Database.pkg_list(@@db, 'req')
    if @@lists[1] == false
      @@lists = {:status => -1, :msg => 'Unable to open database'}
    else
      @@lists = {:status => 0, :data => @@lists[0]}
    end
    JSON.generate(@@lists)
  end
end
