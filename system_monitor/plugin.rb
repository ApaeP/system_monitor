# frozen_string_literal: true
require 'time'

require_relative 'assets/up_arrow'
require_relative 'assets/down_arrow'
require_relative '../kitt_bar_app/assets/b64_logo'

# require_relative 'view'

class Plugin
  attr_reader :refresh_rate

  class << self
    def run(refresh_rate)
      new(refresh_rate).call
    end
  end

  def initialize(refresh_rate)
    @refresh_rate = refresh_rate * 1000 - 100
    # @view = View.new
  end

  def call
    puts get_network_data
    # puts get_network_data
    # start_method
    # @view.generate
  end

  private

  def human_readable_rate(bps)
    rate = if bps < 1024 * 1024
      "#{(bps / 1024.0).round(2)} KB/s"
    elsif bps < 1024 * 1024 * 1024
      "#{(bps / (1024.0 * 1024.0)).round(2)} MB/s"
    else
      "#{(bps / (1024.0 * 1024.0 * 1024.0)).round(2)} GB/s"
    end
    rate.rjust(10)
  end

  def get_network_data
    powermetrics_output = `sudo powermetrics --samplers network -i 100 -n #{@refresh_rate / 100} 2>/dev/null`
    # return nil if powermetrics_output.empty?
    # if powermetrics_output =~ /Network:\s+([\d.]+)%/
    #   return $1.to_f
    # end
    samples = powermetrics_output.scan(/out:\s+[\d.]+\s+packets\/s,\s+([\d.]+)\s+bytes\/s\s*[\r\n]+in:\s+[\d.]+\s+packets\/s,\s+([\d.]+)\s+bytes\/s/)
    return nil if samples.empty?

    total_out = 0.0
    total_in  = 0.0

    samples.each do |out_bytes, in_bytes|
      total_out += out_bytes.to_f
      total_in  += in_bytes.to_f
    end

    count = samples.size
    avg_out = total_out / count
    avg_in  = total_in / count

    "△ #{human_readable_rate(avg_out)} - ▽ #{human_readable_rate(avg_in)} | size=10 trim=false"
  end

  def up_arrow
    "image=#{UP_ARROW}"
  end

  def down_arrow
    "image=#{DOWN_ARROW}"
  end



  def start_method

    # --- Détermination de l'interface réseau par défaut ---
    def get_primary_interface
      route_output = `route get default 2>/dev/null`
      interface_line = route_output.lines.find { |line| line.include?("interface:") }
      if interface_line
        interface_line.split("interface:").last.strip
      else
        "en0"  # valeur par défaut si non trouvé
      end
    end

    # --- Récupération du débit réseau en lecture de l'interface ---
    def get_net_usage(interface)
      # On récupère les compteurs de bytes de l'interface donnée
      netstat_output = `netstat -I #{interface} -b 2>/dev/null`
      lines = netstat_output.lines
      return [nil, nil] if lines.size < 2

      # La deuxième ligne contient les données
      data_line = lines[1].strip
      tokens = data_line.split
      # On s'attend à au moins 10 colonnes : [Name, Mtu, Network, Address, Ipkts, Ierrs, Ibytes, Opkts, Oerrs, Obytes, ...]
      return [nil, nil] if tokens.size < 10

      # Extraction des compteurs (colonnes : Ibytes et Obytes)
      ibytes = tokens[6].to_i
      obytes = tokens[9].to_i
      timestamp = Time.now.to_f

      # Utilisation d'un fichier temporaire pour conserver les valeurs précédentes
      file_path = "/tmp/xbar_net_usage_#{interface}.dat"
      if File.exist?(file_path)
        begin
          prev_data = File.read(file_path).split(',')
          prev_time   = prev_data[0].to_f
          prev_ibytes = prev_data[1].to_i
          prev_obytes = prev_data[2].to_i
        rescue
          prev_time   = timestamp
          prev_ibytes = ibytes
          prev_obytes = obytes
        end
      else
        prev_time   = timestamp
        prev_ibytes = ibytes
        prev_obytes = obytes
      end

      # On sauvegarde les valeurs courantes pour le prochain calcul
      File.write(file_path, "#{timestamp},#{ibytes},#{obytes}")

      delta_time = timestamp - prev_time
      if delta_time <= 0
        download_rate = 0
        upload_rate   = 0
      else
        # Calcul du delta de bytes par seconde
        download_rate = (ibytes - prev_ibytes) / delta_time.to_f
        upload_rate   = (obytes - prev_obytes) / delta_time.to_f
      end

      [download_rate, upload_rate]
    end

    # --- Extraction de l'utilisation CPU via top ---
    def get_cpu_usage
      top_output = `top -l 1 | grep "CPU usage:"`
      return nil if top_output.empty?
      if top_output =~ /CPU usage:\s+([\d.]+)% user,\s+([\d.]+)% sys/
        user = $1.to_f
        sys  = $2.to_f
        total = user + sys
        return total
      end
      nil
    end

    # --- Extraction de l'utilisation RAM via top ---
    def get_ram_usage
      top_output = `top -l 1 | grep PhysMem:`
      return nil if top_output.empty?
      # Exemples de ligne attendue :
      # "PhysMem: 8096M used (2544M wired), 14676M unused."
      if top_output =~ /PhysMem:\s+(\d+)([MG]) used.*,\s+(\d+)([MG]) unused/
        used   = $1.to_f
        unit1  = $2
        unused = $3.to_f
        unit2  = $4

        # Conversion en Mo (MB)
        used_mb   = (unit1 == "G" ? used * 1024 : used)
        unused_mb = (unit2 == "G" ? unused * 1024 : unused)
        total_mb  = used_mb + unused_mb
        usage_percentage = (used_mb / total_mb) * 100
        return usage_percentage
      end
      nil
    end

    # --- Extraction de l'utilisation GPU via powermetrics ---
    def get_gpu_usage
      # La commande powermetrics nécessite sudo (voir la note en début de fichier)
      # powermetrics_output = `sudo powermetrics --samplers gpu -n 1 2>/dev/null`
      # return nil if powermetrics_output.empty?
      # if powermetrics_output =~ /GPU:\s+([\d.]+)%/
      #   return $1.to_f
      # end
      nil
    end

    # --- Récupération et formatage des données ---

    # Interface réseau par défaut
    interface = get_primary_interface

    # Récupération du débit réseau (les taux sont en octets/seconde)
    download_rate, upload_rate = get_net_usage(interface)
    # Conversion en Ko/s (diviser par 1024)
    download_str = download_rate ? "#{(download_rate / 1024).round(1)} KB/s" : "N/A"
    upload_str   = upload_rate   ? "#{(upload_rate   / 1024).round(1)} KB/s" : "N/A"

    cpu_usage = get_cpu_usage
    cpu_str   = cpu_usage ? "#{cpu_usage.round(1)}%" : "N/A"

    ram_usage = get_ram_usage
    ram_str   = ram_usage ? "#{ram_usage.round(1)}%" : "N/A"

    gpu_usage = get_gpu_usage
    gpu_str   = gpu_usage ? "#{gpu_usage.round(1)}%" : "N/A"

    # --- Affichage dans la barre de menu xbar ---
    # La première ligne affichée sert d’aperçu dans la barre
    puts "Net Up #{upload_str} Down #{download_str} CPU #{cpu_str} RAM #{ram_str} GPU #{gpu_str}"

    # Vous pouvez ajouter d'autres lignes ci-dessous pour un menu déroulant détaillé.
    puts "---"
    puts "Interface: #{interface}"
    puts "Débit download: #{download_str}"
    puts "Débit upload:   #{upload_str}"
    puts "CPU usage:      #{cpu_str}"
    puts "RAM usage:      #{ram_str}"
    puts "GPU usage:      #{gpu_str}"
  end
end
