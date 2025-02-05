#!/usr/bin/env ruby
# frozen_string_literal: true

# <xbar.title>System Monitor (Network, CPU, RAM, GPU)</xbar.title>
# <xbar.version>v1.0</xbar.version>
# <xbar.author>Paul P</xbar.author>
# <xbar.author>@ApaeP</xbar.author>
# <xbar.desc>Affiche en temps réel le débit réseau, l'utilisation CPU, RAM et GPU sur macOS.</xbar.desc>
# <xbar.dependencies>ruby, powermetrics (via sudo)</xbar.dependencies>
# <xbar.abouturl>https://example.com</xbar.abouturl>

# Ce plugin se met à jour toutes les 3 secondes.
# Pour récupérer l'utilisation GPU sans invite sudo, pensez à ajouter dans sudoers:
#    votre_nom_d_utilisateur ALL=(root) NOPASSWD: /usr/bin/powermetrics

require_relative 'system_monitor/config/mac_os'
require_relative 'system_monitor/plugin'

exit if lid_is_closed?

REFRESH_RATE = __FILE__[/(?<=\.)\d+(?=s)/].to_i

Plugin.run(REFRESH_RATE)
