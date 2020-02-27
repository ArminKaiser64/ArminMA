using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CubeToShader : MonoBehaviour
{
    private MeshRenderer cubeRenderer;
    private Material cubeMaterial;
    public float rightBorder;
    public float leftBorder;
    public float bottomBorder;
    public float topBorder;
    public float counter = 0.3f;
    private void Awake()
    {
        

    }
    // Start is called before the first frame update
    void Start()
    {

        cubeRenderer = GetComponent<MeshRenderer>();
        rightBorder = gameObject.transform.position.x + gameObject.transform.localScale.x / 2;
        leftBorder = gameObject.transform.position.x - gameObject.transform.localScale.x / 2;
        bottomBorder = gameObject.transform.position.y - gameObject.transform.localScale.y / 2;
        topBorder = gameObject.transform.position.y + gameObject.transform.localScale.y / 2;

        cubeRenderer.material.SetFloat("_RightBorder", rightBorder);
        cubeRenderer.material.SetFloat("_LeftBorder", leftBorder);
        cubeRenderer.material.SetFloat("_TopBorder", topBorder);
        cubeRenderer.material.SetFloat("_BottomBorder", bottomBorder);


    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.R))
        {
            counter += 0.1f;
            //cubeMaterial.SetFloat("_RightBorder", counter);
            //cubeRenderer.GetComponent<Material>().SetFloat("_RightBorder", counter);
            cubeRenderer.material.SetFloat("_RightBorder", counter);
            //cubeMaterial.SetFloat("_RightBorder", counter);
        }
        
    }
}
