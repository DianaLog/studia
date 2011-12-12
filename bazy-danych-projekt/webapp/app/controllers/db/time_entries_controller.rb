module Db
  class TimeEntriesController < ApplicationController
    inherit_resources

    before_filter :authenticate_user!
    before_filter :fetch_parent

    def create
      @time_entry = Db::TimeEntry.new(params[:java_db_time_entry])
      @time_entry.user = current_user
      if @time_entry.save
        @parent.addTimeEntry(@time_entry)
        redirect_to @r.call(@parent)
      else
        render :new
      end
    end

    protected

    def fetch_parent
      id_key,v = {
        :task_id      => [Db::Task,      lambda {|t| project_task_path(t.project ,t) }],
      }.find {|k,cls| params[k] }
      cls, @r = v
      @parent = cls.find(params[id_key])
    end
  end
end
