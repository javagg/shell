require 'rubygems'
require 'rufus/scheduler'
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'tasks/rails'
require 'date'

scheduler = Rufus::Scheduler.start_new

scheduler.cron '0 0 0 * * *' do
  # every day at 00:00
  Rails.logger.info "Expiration reminding check..."
  Archive.check_expiration
  Contract.check_expiration
  License.check_expiration
  Rails.logger.info "...done"

  Rails.logger.info "Payment reminding check..."
  Contract.check_payment
  Rails.logger.info "...done"
end
