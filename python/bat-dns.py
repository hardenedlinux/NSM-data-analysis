# %%
from bat import bro_log_reader

# %%
reader = bro_log_reader.BroLogReader('../logs/zeek/dns.log')

# %%
for row in reader.readrows():
    print(row)

