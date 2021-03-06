
#
# Specifying rufus-scheduler
#
# Sat Mar 21 12:55:27 JST 2009
#

require File.join(File.dirname(__FILE__), 'spec_base')


describe Rufus::CronLine do

  def cl(cronline_string)
    Rufus::CronLine.new(cronline_string)
  end

  def match(line, time)
    cl(line).matches?(time).should == true
  end
  def to_a(line, array)
    cl(line).to_array.should == array
  end

  def local(*args)
    Time.local(*args)
  end
  def utc(*args)
    Time.utc(*args)
  end

  describe '.new' do

    it 'interprets cron strings correctly' do

      to_a '* * * * *', [ [0], nil, nil, nil, nil, nil, nil ]
      to_a '10-12 * * * *', [ [0], [10, 11, 12], nil, nil, nil, nil, nil ]
      to_a '* * * * sun,mon', [ [0], nil, nil, nil, nil, [0, 1], nil ]
      to_a '* * * * mon-wed', [ [0], nil, nil, nil, nil, [1, 2, 3], nil ]
      to_a '* * * * 7', [ [0], nil, nil, nil, nil, [0], nil ]
      to_a '* * * * 0', [ [0], nil, nil, nil, nil, [0], nil ]
      to_a '* * * * 0,1', [ [0], nil, nil, nil, nil, [0,1], nil ]
      to_a '* * * * 7,1', [ [0], nil, nil, nil, nil, [0,1], nil ]
      to_a '* * * * 7,0', [ [0], nil, nil, nil, nil, [0], nil ]
      to_a '* * * * sun,2-4', [ [0], nil, nil, nil, nil, [0, 2, 3, 4], nil ]

      to_a '* * * * sun,mon-tue', [ [0], nil, nil, nil, nil, [0, 1, 2], nil ]

      to_a '* * * * * *', [ nil, nil, nil, nil, nil, nil, nil ]
      to_a '1 * * * * *', [ [1], nil, nil, nil, nil, nil, nil ]
      to_a '7 10-12 * * * *', [ [7], [10, 11, 12], nil, nil, nil, nil, nil ]
      to_a '1-5 * * * * *', [ [1,2,3,4,5], nil, nil, nil, nil, nil, nil ]
    end

    it 'interprets cron strings with TZ correctly' do

      to_a '* * * * * EST', [ [0], nil, nil, nil, nil, nil, 'EST' ]
      to_a '* * * * * * EST', [ nil, nil, nil, nil, nil, nil, 'EST' ]

      lambda { cl '* * * * * NotATimeZone' }.should raise_error
      lambda { cl '* * * * * * NotATimeZone' }.should raise_error
    end
  end

  describe '#next_time' do

    def nt(cronline, now)
      Rufus::CronLine.new(cronline).next_time(now)
    end

    it 'computes the next occurence correctly' do

      now = Time.at(0).getutc # Thu Jan 01 00:00:00 UTC 1970

      nt('* * * * *', now).should == now + 60
      nt('* * * * sun', now).should == now + 259200
      nt('* * * * * *', now).should == now + 1
      nt('* * 13 * fri', now).should == now + 3715200

      nt('10 12 13 12 *', now).should == now + 29938200
        # this one is slow (1 year == 3 seconds)

      nt('0 0 * * thu', now).should == now + 604800

      now = local(2008, 12, 31, 23, 59, 59, 0)

      nt('* * * * *', now).should == now + 1
    end

#
# the specs that follow are from Tanzeeb Khalili
#

    it 'computes the next occurence correctly in UTC (TZ not specified)' do

      now = utc(1970, 1, 1)

      nt('* * * * *', now).should == utc(1970, 1, 1, 0, 1)
      nt('* * * * sun', now).should == utc(1970, 1, 4)
      nt('* * * * * *', now).should == utc(1970, 1, 1, 0, 0, 1)
      nt('* * 13 * fri', now).should == utc(1970, 2, 13)

      nt('10 12 13 12 *', now).should == utc(1970, 12, 13, 12, 10)
        # this one is slow (1 year == 3 seconds)
      nt('* * 1 6 *', now).should == utc(1970, 6, 1)

      nt('0 0 * * thu', now).should == utc(1970, 1, 8)
    end

    it 'computes the next occurence correctly in local TZ (TZ not specified)' do

      now = local(1970, 1, 1)

      nt('* * * * *', now).should == local(1970, 1, 1, 0, 1)
      nt('* * * * sun', now).should == local(1970, 1, 4)
      nt('* * * * * *', now).should == local(1970, 1, 1, 0, 0, 1)
      nt('* * 13 * fri', now).should == local(1970, 2, 13)

      nt('10 12 13 12 *', now).should == local(1970, 12, 13, 12, 10)
        # this one is slow (1 year == 3 seconds)
      nt('* * 1 6 *', now).should == local(1970, 6, 1)

      nt('0 0 * * thu', now).should == local(1970, 1, 8)
    end

    it 'computes the next occurence correctly in UTC (TZ specified)' do

      zone = 'Europe/Stockholm'
      tz = TZInfo::Timezone.get(zone)
      now = tz.local_to_utc(local(1970, 1, 1))
        # Midnight in zone, UTC

      nt("* * * * * #{zone}", now).should == utc(1969, 12, 31, 23, 1)
      nt("* * * * sun #{zone}", now).should == utc(1970, 1, 3, 23)
      nt("* * * * * * #{zone}", now).should == utc(1969, 12, 31, 23, 0, 1)
      nt("* * 13 * fri #{zone}", now).should == utc(1970, 2, 12, 23)

      nt("10 12 13 12 * #{zone}", now).should == utc(1970, 12, 13, 11, 10)
      nt("* * 1 6 * #{zone}", now).should == utc(1970, 5, 31, 23)

      nt("0 0 * * thu #{zone}", now).should == utc(1970, 1, 7, 23)
    end

    #it 'computes the next occurence correctly in local TZ (TZ specified)' do
    #  zone = 'Europe/Stockholm'
    #  tz = TZInfo::Timezone.get(zone)
    #  now = tz.local_to_utc(utc(1970, 1, 1)).localtime
    #    # Midnight in zone, local time
    #  nt("* * * * * #{zone}", now).should == local(1969, 12, 31, 18, 1)
    #  nt("* * * * sun #{zone}", now).should == local(1970, 1, 3, 18)
    #  nt("* * * * * * #{zone}", now).should == local(1969, 12, 31, 18, 0, 1)
    #  nt("* * 13 * fri #{zone}", now).should == local(1970, 2, 12, 18)
    #  nt("10 12 13 12 * #{zone}", now).should == local(1970, 12, 13, 6, 10)
    #  nt("* * 1 6 * #{zone}", now).should == local(1970, 5, 31, 19)
    #  nt("0 0 * * thu #{zone}", now).should == local(1970, 1, 7, 18)
    #end
  end

  describe '#matches?' do

    it 'matches correctly in UTC (TZ not specified)' do

      match '* * * * *', utc(1970, 1, 1, 0, 1)
      match '* * * * sun', utc(1970, 1, 4)
      match '* * * * * *', utc(1970, 1, 1, 0, 0, 1)
      match '* * 13 * fri', utc(1970, 2, 13)

      match '10 12 13 12 *', utc(1970, 12, 13, 12, 10)
      match '* * 1 6 *', utc(1970, 6, 1)

      match '0 0 * * thu', utc(1970, 1, 8)
    end

    it 'matches correctly in local TZ (TZ not specified)' do

      match '* * * * *', local(1970, 1, 1, 0, 1)
      match '* * * * sun', local(1970, 1, 4)
      match '* * * * * *', local(1970, 1, 1, 0, 0, 1)
      match '* * 13 * fri', local(1970, 2, 13)

      match '10 12 13 12 *', local(1970, 12, 13, 12, 10)
      match '* * 1 6 *', local(1970, 6, 1)

      match '0 0 * * thu', local(1970, 1, 8)
    end

    it 'matches correctly in UTC (TZ specified)' do

      zone = 'Europe/Stockholm'

      match "* * * * * #{zone}", utc(1969, 12, 31, 23, 1)
      match "* * * * sun #{zone}", utc(1970, 1, 3, 23)
      match "* * * * * * #{zone}", utc(1969, 12, 31, 23, 0, 1)
      match "* * 13 * fri #{zone}", utc(1970, 2, 12, 23)

      match "10 12 13 12 * #{zone}", utc(1970, 12, 13, 11, 10)
      match "* * 1 6 * #{zone}", utc(1970, 5, 31, 23)

      match "0 0 * * thu #{zone}", utc(1970, 1, 7, 23)
    end
  end
end

