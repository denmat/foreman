module HostsAndHostgroupsHelper
  def hostgroup_name group
    return if group.blank?
    content_tag(:span, group.to_s.gsub(group.name, ""), :class => "grey") +
      link_to_if_authorized(h(group.name), hash_for_edit_hostgroup_path(:id => group))
  end

  def accessible_hostgroups
    hg = (User.current.hostgroups.any? and !User.current.admin?) ? User.current.hostgroups : Hostgroup.all
    hg.sort
  end

  def image_file_entry f, item
    # If the host has an explicit image_path then use that
    # Else use the default based upon the host's medium and operatingsystem
    value = (item.use_image && item.image_file) || item.default_image_file
    text_f f, :image_file, :value => value, :disabled => !item.use_image,
                 :id => type + "_image_file", :name => type + "[image_file]", :class => "xxlarge"
  end

  def parent_classes obj
    return obj.hostgroup.classes if obj.is_a?(Host) and obj.hostgroup
    return obj.is_root? ? [] : obj.parent.classes if obj.is_a?(Hostgroup)
    []
  end

  def select_hypervisor item
    options_for_select Hypervisor.all.map{|h| [h.name, h.id]}, item.try(:hypervisor_id).try(:to_i)
  end

  def select_memory item = nil
    memory = item.try(:memory) if item
    memory ||= @guest.memory if @guest
    options_for_select Hypervisor::MEMORY_SIZE.map {|mem| [number_to_human_size(mem*1024), mem]}, memory.to_i
  end

  def volume_size item
    return item.disk_size if item.try(:disk_size)
    return @guest.volume.size if @guest
  end

  def accessible_domains
    (User.current.domains.any? and !User.current.admin?) ? User.current.domains : Domain.all
  end

  def domain_subnets
    return [] if @domain.blank?
    @domain.subnets
  end

  def arch_oss
    return [] if @architecture.blank?
    @architecture.operatingsystems
  end

  def os_media
    return [] if @operatingsystem.blank?
    @operatingsystem.media
  end

  def os_ptable
    return [] if @operatingsystem.blank?
    @operatingsystem.ptables
  end

end
