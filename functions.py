# functions
def write_list(input:list,output_path:str):
    """
    saves a list (input) to a txt file (output_path), confirmation output currently commented out, no return values 
    """    
    with open(output_path, 'w') as content:
        content.writelines('\n'.join(input))
    #print(f'list exported to {output_path}')    
def open_list(input:list,file_path:str):
    """
    opens a txt file from path (file_path) as a pre-defined list name (input), list & confirmation output currently commented out, appended list is returned  
    """    
    with open(file_path, 'r') as content:
        for line in content:
            x = line.replace('\n','')
            input.append(x)      
    #print(input)
    #print(f'list imported from {file_path}')  
