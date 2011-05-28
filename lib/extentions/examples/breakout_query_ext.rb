# created by Titas Norkūnas
# run specs by file contents extention for Breakout
# run specs by components

module BreakoutQuery
  USE_CASE = "\nBreakout use cases:\n
    1. Run specs by Breakout components. Use any (or just unique prefix) component name
    rake q:spec g=Alerts
    # runs all specs related to Alerts component
    rake q:spec g=ag
    # runs all specs related to Agile Planner component, as ag is unique prefix for this component
    2. Provided there is a change related to space backups. To run only tests that can be related.
    rake q:spec q=backup
    3. Provided there are some changes related to portfolio views. To run only specs that can be related:
    rake q:spec q='portfolio&&template||portfolio&&view'
    # this will run all specs that have: (('portfolio' AND 'template') OR ('portfolio' AND 'view'))
    4. Provided someone changed :space and :ticket factories. To run tests that use them:
    rake q:spec q='Factory :space||Factory :ticket --c'
    # this will run all specs that have either \"Factory :space\" OR \"Factory :ticket\" text. --c is for case-sensitive"

  GROUP = "Please supply query q=query or g=group parameter for this rake task"

  # TODO
  # * add tags for missing components
  COMPONENT_HASH = {
    "Agile Planner"             => "agile&&planner",
    "Alerts"                    => "alerter||user_notify",
    "App Admin"                 => "admin",
    "Branded spaces"            => "?",
    "BreakoutParser"            => "breakout&&parser",
    "Catalog"                   => "?",
    "Chat"                      => "chat",
    "Commercial"                => "?",
    "Core"                      => "?",
    "Core - spaces"             => "?",
    "Core - users"              => "?",
    "Core-processors"           => "?",
    "cron tasks scripts"        => "?",
    "Custom Status"             => "ticket_status",
    "Dashboard"                 => "?",
    "Events"                    => "event",
    "Files"                     => "?",
    "Fork and Merge"            => "fork||merge",
    "FTP Tool"                  => "ftp",
    "Gerrit"                    => "gerrit",
    "Help and Docs"             => "?",
    "Home / Marketing"          => "?",
    "I18N"                      => "?",
    "Image annotation"          => "?",
    "Jobs/recruit/contract"     => "?",
    "Messages"                  => "?",
    "Milestones"                => "milestone",
    "New Tools"                 => "?",
    "Other"                     => "?",
    "Other Tools"               => "?",
    "Performance"               => "?",
    "Portfolio#Admin"           => "portfolio&&admin",
    "Portfolio#BrandingAndHome" => "portfolio&&brand",
    "Portfolio#Filters"         => "portfolio&&filter",
    "Portfolio#Projects"        => "portfolio&&project",
    "Portfolio#Start"           => "?",
    "Portfolio#Stream"          => "?",
    "Portfolio#Tickets"         => "portfolio&&ticket",
    "Portfolio#Time"            => "portfolio&&time",
    "Portfolio#Users"           => "portfolio&&user",
    "Private Installation"      => "?",
    "Project Portfolio"         => "?",
    "RCB"                       => "rcb",
    "Repo Exp."                 => "?",
    "Repositories"              => "?",
    "REST-auth module"          => "?",
    "Scrum tool"                => "?",
    "Search"                    => "?",
    "Server admin"              => "?",
    "Server Tool"               => "?",
    "Site Architecture"         => "?",
    "Skype"                     => "?",
    "Spaces Admin"              => "?",
    "Staffing"                  => "?",
    "Support"                   => "?",
    "Ticket tool"               => "?",
    "Time tool"                 => "?",
    "Time/bill/pay"             => "?",
    "Tool Permissions"          => "permission",
    "Trac"                      => "trac",
    "Wiki"                      => "wiki"
  }


  def initialize(*args)
    self.extend BreakoutQuery::QueryMethods
  end

  module QueryMethods
    def help
      help_info    = super
      help_info[0] = GROUP
      help_info + [USE_CASE]
    end

    def env_condition
      super || env["g"]
    end

     def make_query
       group = env["g"]
       if group
         key, value = get_group(group)
         puts "Running specs for: #{key}"
         value
       else
        super
      end
    end

    private

    def get_group(group)
      c = COMPONENT_HASH[group]
      if c == "?"
        puts "Group not implemented"
        exit 1
      else
        return [group, c] if c.present?
        # if only one key starts with group
        keys = COMPONENT_HASH.keys.select do |k|
          k.downcase.start_with?(group.downcase)
        end
        if keys.length == 1
          return [keys.first, COMPONENT_HASH[keys.first]]
        else
          puts "Please be more specific, multiple matches:", keys
          exit 1
        end
      end
    end
  end
end

