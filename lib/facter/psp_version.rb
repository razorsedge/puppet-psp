Facter.add("psp_version") do
    confine :manufacturer => "HP"
    confine :operatingsystem => %w{RedHat CentOS OracleLinux OEL}
    setcode do
        # PSP 7.x note can only validate x.x version and not x.x.x
        old_psp = "hpasm"
        # PSP 8.x and above
        new_psp = "hp-snmp-agents"
        if system("rpm -q #{old_psp} > /dev/null")
            version = %x[rpm -q #{old_psp}]
            version =~ /.*-(\d+\.\d+\.\d+).*/
            $1
        elsif system("rpm -q #{new_psp} > /dev/null")
            version = %x[rpm -q #{new_psp}]
            version =~ /.*-(\d+\.\d+\.\d+).*/
            $1
        else
            version = "0.0.0"
            version
        end
    end
end
