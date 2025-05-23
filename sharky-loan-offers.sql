with txs as (

-- single loan offer
select tx_id, block_timestamp as datetime, signers[0] as lender, inner_instructions[0]:instructions[2]:parsed:info:destination as escrow_token
from solana.core.fact_transactions
where (contains (log_messages[1],'OfferLoan') or contains (log_messages[5],'OfferLoan'))
and block_timestamp > current_date() - interval '3 day'
and succeeded
and signers[2] is null
and (instructions[0]:accounts[6] = '5274Bqe6RmGkxw6E6M7pYpEkJFh4VS7mcZQe2mQ6ZRLC' or instructions[2]:accounts[6] = '5274Bqe6RmGkxw6E6M7pYpEkJFh4VS7mcZQe2mQ6ZRLC')
union all
-- 3 loans offered 
select tx_id, block_timestamp as datetime, signers[0] as lender, inner_instructions[0]:instructions[2]:parsed:info:destination as escrow_token
from solana.core.fact_transactions
where contains (log_messages[5],'OfferLoan')
and block_timestamp > current_date() - interval '3 day'
and succeeded
and signers[3] is not null
and signers[4] is null
and instructions[2]:accounts[6] = '5274Bqe6RmGkxw6E6M7pYpEkJFh4VS7mcZQe2mQ6ZRLC'
union all
select tx_id, block_timestamp as datetime, signers[0] as lender, inner_instructions[1]:instructions[2]:parsed:info:destination as escrow_token
from solana.core.fact_transactions
where contains (log_messages[5],'OfferLoan')
and block_timestamp > current_date() - interval '3 day'
and succeeded
and signers[3] is not null
and signers[4] is null
and instructions[2]:accounts[6] = '5274Bqe6RmGkxw6E6M7pYpEkJFh4VS7mcZQe2mQ6ZRLC'
union all
select tx_id, block_timestamp as datetime, signers[0] as lender, inner_instructions[2]:instructions[2]:parsed:info:destination as escrow_token
from solana.core.fact_transactions
where contains (log_messages[5],'OfferLoan')
and block_timestamp > current_date() - interval '3 day'
and succeeded
and signers[3] is not null
and signers[4] is null
and instructions[2]:accounts[6] = '5274Bqe6RmGkxw6E6M7pYpEkJFh4VS7mcZQe2mQ6ZRLC'

), 
bal as (
select account_address, min(balance) as amount
from solana.core.fact_sol_balances
where account_address in (select txs.escrow_token from txs)
group by 1
)
select round(amount, 2) as amount, concat(substring(lender,1,3)||'___'||substring(lender,42,44)) as user_readable, substring(cast(datetime as varchar),1,16) as datetime
from txs
join bal on bal.account_address = txs.escrow_token
where amount > 0.01
order by 1 desc
;
