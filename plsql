declare
 TYPE typ_ibt_name IS TABLE OF varchar2(200)
          INDEX BY BINARY_INTEGER;
          
           TYPE typ_ibt_name2 IS TABLE OF varchar2(200)
          INDEX BY BINARY_INTEGER;
    
      
   
      ibt_names typ_ibt_name;
      ibt_names2 typ_ibt_name2;
      
      varia PLS_INTEGER := 1;
   
      v_counter PLS_INTEGER := 0;
   
      /* Explicit cursor required... */
      CURSOR cur
     IS
         SELECT name
        FROM   tempo_clientes;
         
   
      /* Our "batch" size... */
      c_batch CONSTANT PLS_INTEGER := 1000;
   
   BEGIN
   
      /* Loop the cursor... */
      OPEN cur;
      LOOP
   
         /* Fetch in batches... */
         FETCH cur
         BULK COLLECT INTO ibt_names LIMIT c_batch;
   
         IF ibt_names.COUNT > 0 THEN
   
          /* Do some "processing"... */
            v_counter := v_counter + ibt_names.COUNT;
            
            for i IN 1 .. ibt_names.COUNT LOOP
                
            DBMS_OUTPUT.PUT_LINE(ibt_names(i));
            
            declare
            
            CURSOR cur2
            IS
            SELECT name
            FROM   tempo_investigados;
            
            begin
            
                OPEN cur2;
                    LOOP
   
                /* Fetch in batches... */
                FETCH cur2
                BULK COLLECT INTO ibt_names2 LIMIT c_batch;
                
                for O IN 1 .. ibt_names2.COUNT LOOP
                varia := varia + 1;
                END LOOP;
                
                EXIT WHEN cur2%NOTFOUND;
   
                END LOOP;
                CLOSE cur2;
                
            end;
   
            END LOOP;

         END IF;
   
         /* Critical placement of EXIT condition... */
         EXIT WHEN cur%NOTFOUND;
   
      END LOOP;
      CLOSE cur;
   
      DBMS_OUTPUT.PUT_LINE (
         'We fetched ' || TO_CHAR ( v_counter ) ||
            ' records ' || TO_CHAR ( c_batch ) ||
               ' records at a time.'  );
               
               DBMS_OUTPUT.PUT_LINE (varia);
               DBMS_OUTPUT.PUT_LINE (to_char(varia));
   
   END;
