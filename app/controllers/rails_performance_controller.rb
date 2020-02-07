class RailsPerformanceController < ActionController::Base

  def index
    @datasource                = RP::DataSource.new(RP::Rails::QueryBuilder.compose_from(params))
    db                         = @datasource.db

    @throughput_report         = RP::Reports::ThroughputReport.new(db)
    @throughput_report_data    = @throughput_report.data

    @response_time_report      = RP::Reports::ResponseTimeReport.new(db)
    @response_time_report_data = @response_time_report.data
  end

  def crashes
    @datasource                = RP::DataSource.new(RP::Rails::QueryBuilder.compose_from({status_eq: 500}))
    db                         = @datasource.db
    @crash_report              = RP::Reports::CrashReport.new(db)
    @crash_report_data         = @crash_report.data
  end

  def requests
    @datasource                = RP::DataSource.new(RP::Rails::QueryBuilder.compose_from(params))
    db                         = @datasource.db

    @global_report             = RP::Reports::RequestsReport.new(db, group: :controller_action_format, sort: :db_runtime_slowest)
    @global_report_data        = @global_report.data
  end

  def breakdown
    @datasource = RP::DataSource.new(RP::Rails::QueryBuilder.compose_from(params))
    db          = @datasource.db

    @breakdown_report      = RP::Reports::BreakdownReport.new(db, title: "Breakdown Report: #{@datasource.q.to_param}")
    @breakdown_report_data = @breakdown_report.data
  end

end
