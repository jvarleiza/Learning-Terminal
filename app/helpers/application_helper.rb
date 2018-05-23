# Application-wide view helper, which is automatically included in views but not
# controllers or models.
module ApplicationHelper
    def decode_links str
        ret = []
        all_links = str && str.split("@@")
        if all_links
            all_links.each do |link|
                link_parts = link.split("##")
                ret.push({ name: link_parts[0], url: link_parts[1] })
            end
        end
        return ret
    end
    
    def decode_list str, hash=nil
        ret = []
        all_items = str && str.split("@@")
        
        if hash
            all_items.each { |item| ret.push(hash[item]) } if !all_items.nil?
        else
            all_items.each { |item| ret.push(item) } if !all_items.nil?
        end
        
        return ret
    end
    
    def get_video videos, video_num
        ret = ''
        if !videos.blank?
            vidUrls = videos.split('@@').map {|v| "https://broadcast.amazon.com/videos/#{v}" }
            if !vidUrls[video_num].blank?
                ret = vidUrls[video_num]
            end
        end
        return ret
    end 
    
    def print_option_should_appear
        path = Rails.application.routes.recognize_path(request.path)
        c = path[:controller]
        return path[:action] == 'show' && (c == 'tasks' || c == 'roles' || c == 'process_lts')
    end
    
    def correct_locale entity
        !entity.nil? && entity.locale == cookies[:language_code]
    end
    
    def get_task_color type
        return "background-color:#{@app_config['task-colors'][type]};height:25px;width:25px;float:right;border-radius:50px"
    end
    
    def get_task_color_no_float type
        return "background-color:#{@app_config['task-colors'][type]};height:25px;width:25px;border-radius:50px;display:inline-block"
    end
    
    # Only for tasks
    def show_task_schedule_correctly task
        ret = @days_of_week[task.day_of_week.to_s]
        if task.mark_start
            hour_start = task.hour_start < 10 ? '0' + task.hour_start.to_s : task.hour_start
            min_start = task.min_start < 10 ? '0' + task.min_start.to_s : task.min_start
            ret = ret + ", #{hour_start}:#{min_start}"
        end
        return ret
    end
    
    def get_style_for_time_div task
        return @task.mark_start ? "display:inline-block" : "display:none"
    end
    
    def get_value_or_default value, default
        return value.blank? ? default : value
    end
    
    def print_no_content_message msg
        raw "<div class=\"no-content-messages\">
            <p>#{t(msg)}</p>
        </div>"
    end
    
    def render_translations trans
        ret = []
        trans.each do |t|
            ret.push link_to(t(t[:locale]), t[:url])
        end
        return ret.join(' - ')
    end
end
