class StatsController < ApplicationController

  

  def index
    return render_403 unless User.current.allowed_to?(:view_server_stats, nil, :global => true)
    # ottengo server load e ram usata
    ram_cpu_rows = [
      ['Uso ram',      `free -m | grep 'Mem:' | awk '{ print $3"/"$2" MB" }'`.strip],
      ['Uso swap',     `free -m | grep 'Swap:' | awk '{ print $3"/"$2" MB" }'`.strip],
      ['Load average', `cat /proc/loadavg | awk '{ print $1"/"$2"/"$3 }'`.strip]
    ]
    ram_cpu = {:header => ['Elemento', 'Valore'], :rows => ram_cpu_rows}

    # ottengo lo stato dischi
    stato_dischi_rows = [`df -h | grep '/$' | awk '{ print $1"|"$2"|"$3"|"$4"|"$5"|"$6 }'`.strip.split('|')]
    stato_dischi = {:header => ['Nome disco','Spazio totale','Spazio usato','Spazio disponibile','Percentuale di uso','Mountpoint'], 
                    :rows => stato_dischi_rows}

    # ottengo spazio occupato da cose varie
    varie_rows = [
      ['Allegati redmine',   `du -sh "/opt/redmine/redmine-files" | awk '{ print $1 }'`.strip],
      ['Repo git',           `du -sh "/var/log" | awk '{ print $1 }'`.strip],
      ['File di log server', `du -sh "/opt/redmine/redmine-repos" | awk '{ print $1 }'`.strip]
    ]
    varie = {:header => ['Elemento', 'Spazio usato'], :rows => varie_rows}

    @sts = {'Ram e CPU': ram_cpu, 'Stato dischi': stato_dischi, 'Varie': varie}
  end
end

  
# Formato dati per essere stampati
  
# sts:         hashmap con :nome_tabella => {tabella:hash_map}
# tabella:     hashmap con :header => [lista_titoli:lista]  
#                          :rows   => [lista_righe:lista] 
# lista_righe: lista con liste di valori 